const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api'

export async function getRandomDish() {
  try {
    const response = await fetch(`${API_BASE_URL}/random-dish`)
    const data = await response.json()

    if (!response.ok) {
      throw new Error(data.message || '获取菜单失败')
    }

    if (!data.success) {
      throw new Error(data.message || '获取菜单失败')
    }

    return data.data
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('网络连接失败，请检查后端服务是否运行')
    }
    throw error
  }
}

export async function getAllDishes(page = 1, limit = 10) {
  try {
    const response = await fetch(
      `${API_BASE_URL}/dishes?page=${page}&limit=${limit}`
    )
    const data = await response.json()

    if (!response.ok) {
      throw new Error(data.message || '获取菜单列表失败')
    }

    return data
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('网络连接失败，请检查后端服务是否运行')
    }
    throw error
  }
}

export async function searchDishes(keyword) {
  try {
    const response = await fetch(
      `${API_BASE_URL}/search?keyword=${encodeURIComponent(keyword)}`
    )
    const data = await response.json()

    if (!response.ok) {
      throw new Error(data.message || '搜索失败')
    }

    return data.data
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('网络连接失败，请检查后端服务是否运行')
    }
    throw error
  }
}

export async function addDish(name, description, category) {
  try {
    const response = await fetch(`${API_BASE_URL}/dishes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ name, description, category }),
    })

    const data = await response.json()

    if (!response.ok) {
      throw new Error(data.message || '添加菜单失败')
    }

    return data.data
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('网络连接失败，请检查后端服务是否运行')
    }
    throw error
  }
}
