#!/usr/bin/env python3
"""
自动将 Swift 文件添加到 Xcode 项目的脚本
"""

import os
import uuid
import re

# 项目路径
project_path = '/Users/dangchy/RnWorkspace/viteWorkspace/WhatEating/WhatEatingApp/WhatEatingApp.xcodeproj/project.pbxproj'

# 需要添加的文件
files_to_add = [
    ('Models/Dish.swift', 'Models'),
    ('Services/APIService.swift', 'Services'),
    ('Views/HeaderView.swift', 'Views'),
    ('Views/InputSectionView.swift', 'Views'),
    ('Views/ActionButtonView.swift', 'Views'),
    ('Views/ResultDisplayView.swift', 'Views'),
]

def generate_uuid():
    """生成 24 位 Xcode 风格的 UUID"""
    return uuid.uuid4().hex[:24].upper()

def read_project():
    """读取项目文件"""
    with open(project_path, 'r', encoding='utf-8') as f:
        return f.read()

def write_project(content):
    """写入项目文件"""
    with open(project_path, 'w', encoding='utf-8') as f:
        f.write(content)

def add_files_to_project():
    """将文件添加到项目"""
    print("📦 读取 Xcode 项目文件...")
    content = read_project()
    
    # 查找主 group 的 UUID
    main_group_match = re.search(r'(\w{24}) /\* WhatEatingApp \*/ = \{[^}]*isa = PBXGroup', content)
    if not main_group_match:
        print("❌ 无法找到主 group")
        return False
    
    main_group_uuid = main_group_match.group(1)
    print(f"✅ 找到主 group UUID: {main_group_uuid}")
    
    # 查找 PBXSourcesBuildPhase 的 UUID
    sources_build_phase_match = re.search(r'(\w{24}) /\* Sources \*/ = \{[^}]*isa = PBXSourcesBuildPhase', content)
    if not sources_build_phase_match:
        print("❌ 无法找到 Sources build phase")
        return False
    
    sources_build_phase_uuid = sources_build_phase_match.group(1)
    print(f"✅ 找到 Sources build phase UUID: {sources_build_phase_uuid}")
    
    # 存储生成的 UUIDs
    file_refs = {}
    build_file_refs = {}
    group_refs = {
        'Models': None,
        'Services': None,
        'Views': None
    }
    
    # 为每个 group 生成 UUID
    for group_name in group_refs.keys():
        group_refs[group_name] = generate_uuid()
    
    # 为每个文件生成 UUIDs
    for file_path, group_name in files_to_add:
        file_name = os.path.basename(file_path)
        file_ref_uuid = generate_uuid()
        build_file_uuid = generate_uuid()
        
        file_refs[file_path] = (file_ref_uuid, file_name)
        build_file_refs[file_path] = build_file_uuid
    
    # 构建 PBXFileReference 部分
    print("\n📝 生成 PBXFileReference 条目...")
    file_reference_section = ""
    for file_path, (file_ref_uuid, file_name) in file_refs.items():
        file_reference_section += f'\t\t{file_ref_uuid} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_name}; sourceTree = "<group>"; }};\n'
    
    # 插入 PBXFileReference
    pbx_file_ref_end = content.find('/* End PBXFileReference section */')
    if pbx_file_ref_end == -1:
        print("❌ 无法找到 PBXFileReference section")
        return False
    
    content = content[:pbx_file_ref_end] + file_reference_section + content[pbx_file_ref_end:]
    
    # 构建 PBXBuildFile 部分
    print("📝 生成 PBXBuildFile 条目...")
    build_file_section = ""
    for file_path, build_file_uuid in build_file_refs.items():
        file_ref_uuid, file_name = file_refs[file_path]
        build_file_section += f'\t\t{build_file_uuid} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* {file_name} */; }};\n'
    
    # 插入 PBXBuildFile
    pbx_build_file_end = content.find('/* End PBXBuildFile section */')
    if pbx_build_file_end == -1:
        print("❌ 无法找到 PBXBuildFile section")
        return False
    
    content = content[:pbx_build_file_end] + build_file_section + content[pbx_build_file_end:]
    
    # 创建 PBXGroup 部分
    print("📝 生成 PBXGroup 条目...")
    group_section = ""
    
    for group_name, group_uuid in group_refs.items():
        # 找到属于这个 group 的文件
        group_files = [(fp, file_refs[fp]) for fp, gn in files_to_add if gn == group_name]
        
        group_section += f'\t\t{group_uuid} /* {group_name} */ = {{\n'
        group_section += f'\t\t\tisa = PBXGroup;\n'
        group_section += f'\t\t\tchildren = (\n'
        
        for _, (file_ref_uuid, file_name) in group_files:
            group_section += f'\t\t\t\t{file_ref_uuid} /* {file_name} */,\n'
        
        group_section += f'\t\t\t);\n'
        group_section += f'\t\t\tpath = {group_name};\n'
        group_section += f'\t\t\tsourceTree = "<group>";\n'
        group_section += f'\t\t}};\n'
    
    # 插入 PBXGroup
    pbx_group_end = content.find('/* End PBXGroup section */')
    if pbx_group_end == -1:
        print("❌ 无法找到 PBXGroup section")
        return False
    
    content = content[:pbx_group_end] + group_section + content[pbx_group_end:]
    
    # 更新主 group 的 children
    print("📝 更新主 group...")
    main_group_pattern = f'{main_group_uuid} /\\* WhatEatingApp \\*/ = {{[^{{]*children = \\('
    main_group_match = re.search(main_group_pattern, content)
    
    if main_group_match:
        insert_pos = main_group_match.end()
        group_children = ""
        for group_name, group_uuid in group_refs.items():
            group_children += f'\n\t\t\t\t{group_uuid} /* {group_name} */,'
        
        content = content[:insert_pos] + group_children + content[insert_pos:]
    
    # 更新 Sources build phase
    print("📝 更新 Sources build phase...")
    sources_pattern = f'{sources_build_phase_uuid} /\\* Sources \\*/ = {{[^{{]*files = \\('
    sources_match = re.search(sources_pattern, content)
    
    if sources_match:
        insert_pos = sources_match.end()
        build_files = ""
        for file_path, build_file_uuid in build_file_refs.items():
            file_name = os.path.basename(file_path)
            build_files += f'\n\t\t\t\t{build_file_uuid} /* {file_name} in Sources */,'
        
        content = content[:insert_pos] + build_files + content[insert_pos:]
    
    # 写入更新后的项目文件
    print("\n💾 保存项目文件...")
    write_project(content)
    
    print("✅ 所有文件已成功添加到 Xcode 项目！")
    print("\n📋 已添加的文件:")
    for file_path, group_name in files_to_add:
        print(f"  - {file_path} ({group_name})")
    
    return True

if __name__ == '__main__':
    print("🚀 开始添加文件到 Xcode 项目...\n")
    success = add_files_to_project()
    
    if success:
        print("\n✨ 完成！现在您可以在 Xcode 中打开项目并编译了。")
    else:
        print("\n❌ 添加文件失败，请手动添加。")
