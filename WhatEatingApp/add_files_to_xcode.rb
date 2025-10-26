#!/usr/bin/env ruby

require 'xcodeproj'

# 项目路径
project_path = '/Users/dangchy/RnWorkspace/viteWorkspace/WhatEating/WhatEatingApp/WhatEatingApp.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# 获取主目标
target = project.targets.first

# 获取主组
main_group = project.main_group['WhatEatingApp']

# 创建文件夹组
models_group = main_group.new_group('Models')
services_group = main_group.new_group('Services')
views_group = main_group.new_group('Views')

# 添加文件
files_to_add = {
  models_group => ['Models/Dish.swift'],
  services_group => ['Services/APIService.swift'],
  views_group => [
    'Views/HeaderView.swift',
    'Views/InputSectionView.swift',
    'Views/ActionButtonView.swift',
    'Views/ResultDisplayView.swift'
  ]
}

files_to_add.each do |group, files|
  files.each do |file|
    file_path = "/Users/dangchy/RnWorkspace/viteWorkspace/WhatEating/WhatEatingApp/WhatEatingApp/#{file}"
    file_ref = group.new_file(file_path)
    target.add_file_references([file_ref])
  end
end

# 保存项目
project.save

puts "✅ 所有文件已成功添加到 Xcode 项目！"
