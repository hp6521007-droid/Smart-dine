import React, { useEffect, useState } from 'react'
import Home from './components/Home'
import Menu from './components/Menu'
import FoodDetails from './components/FoodDetails'
import Cart from './components/Cart'
import Orders from './components/Orders'
import Profile from './components/Profile'
import BottomNav from './components/BottomNav'
import OrderConfirmation from './components/OrderConfirmation'
import sampleItems from './data/items'

export default function App(){
  const [route, setRoute] = useState('home')
  const [cart, setCart] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem('sd_cart')) || []
    } catch {
      return []
    }
  })

  const [orders, setOrders] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem('sd_orders')) || []
    } catch {
      return []
    }
  })

  const [items] = useState(sampleItems)
  const [selectedItem, setSelectedItem] = useState(null)
  const [lastPlacedOrder, setLastPlacedOrder] = useState(null)

  useEffect(() => {
    localStorage.setItem('sd_cart', JSON.stringify(cart))
  }, [cart])

  useEffect(() => {
    localStorage.setItem('sd_orders', JSON.stringify(orders))
  }, [orders])

  function addToCart(item){
    setCart(prev => {
      const existing = prev.find(p => p.id === item.id)

      if(existing){
        return prev.map(p =>
          p.id === item.id
            ? { ...p, qty: p.qty + 1 }
            : p
        )
      }

      return [...prev, { ...item, qty: 1 }]
    })
  }

  function decreaseFromCart(item){
    setCart(prev => {
      const existing = prev.find(p => p.id === item.id)

      if(!existing){
        return prev
      }

      if(existing.qty <= 1){
        return prev.filter(p => p.id !== item.id)
      }

      return prev.map(p =>
        p.id === item.id
          ? { ...p, qty: p.qty - 1 }
          : p
      )
    })
  }

  function getCartQty(item){
    const existing = cart.find(p => p.id === item.id)
    return existing ? existing.qty : 0
  }

  function updateCart(updated){
    setCart(updated)
  }

  function openDetails(item){
    setSelectedItem(item)
    setRoute('details')
  }

  function placeDemoOrder(order){
    setOrders(prev => [order, ...prev])
    setCart([])
    setLastPlacedOrder(order)
    setRoute('confirm')
  }

  return (
    <>
      {route === 'home' && (
        <Home
          items={items}
          onAdd={addToCart}
          onRemove={decreaseFromCart}
          getCartQty={getCartQty}
          onOpenMenu={() => setRoute('menu')}
          onOpenDetails={openDetails}
        />
      )}

      {route === 'menu' && (
        <Menu
          items={items}
          onAdd={addToCart}
          onRemove={decreaseFromCart}
          getCartQty={getCartQty}
          onBack={() => setRoute('home')}
          onOpenDetails={openDetails}
        />
      )}

      {route === 'details' && selectedItem && (
        <FoodDetails
          item={selectedItem}
          onAdd={(it) => {
            addToCart(it)
            setRoute('cart')
          }}
          onBack={() => setRoute('menu')}
        />
      )}

      {route === 'cart' && (
        <Cart
          cart={cart}
          updateCart={updateCart}
          onPlaceOrder={placeDemoOrder}
          onBack={() => setRoute('menu')}
        />
      )}

      {route === 'confirm' && lastPlacedOrder && (
        <OrderConfirmation
          order={lastPlacedOrder}
          onDone={() => setRoute('orders')}
        />
      )}

      {route === 'orders' && (
        <Orders
          orders={orders}
          setOrders={setOrders}
        />
      )}

      {route === 'profile' && (
        <Profile
          onPlaceDemoOrder={placeDemoOrder}
          setRoute={setRoute}
        />
      )}

      <BottomNav
        current={route}
        onChange={setRoute}
        cartCount={cart.reduce((s, c) => s + c.qty, 0)}
      />
    </>
  )
}