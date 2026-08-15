#!/usr/bin/env bash
set -e
echo "Creating SMART DINE project files..."

# Make directories
mkdir -p public src src/components src/data src/utils .github/workflows

# index.html
cat > index.html <<'HTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <title>SMART DINE — Mobile Canteen Ordering Prototype</title>
    <link rel="icon" href="/favicon.svg" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
HTML

# vite.config.js
cat > vite.config.js <<'JS'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
export default defineConfig({
  plugins: [react()],
  base: './'
})
JS

# package.json
cat > package.json <<'JSON'
{
  "name": "smart-dine-prototype",
  "version": "1.0.0",
  "private": true,
  "description": "SMART DINE - Mobile-first college canteen ordering prototype",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview --port 4173",
    "deploy": "gh-pages -d dist"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^5.0.0",
    "vite": "^5.0.0",
    "gh-pages": "^5.0.0"
  }
}
JSON

# favicon
cat > public/favicon.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#111827" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="9" fill="#fff8e1" />
  <path d="M8 12h8" stroke="#ef4444" />
  <path d="M12 8v8" stroke="#10b981" />
  <text x="12" y="18.5" text-anchor="middle" font-size="5" fill="#111827" font-family="sans-serif">🍽️</text>
</svg>
SVG

# src/main.jsx
cat > src/main.jsx <<'JS'
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './styles.css'

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <div className="app-phone">
      <div className="app-topbar" />
      <div className="app-main">
        <App />
      </div>
    </div>
  </React.StrictMode>
)
JS

# src/App.jsx
cat > src/App.jsx <<'JS'
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
  const [route, setRoute] = useState('home') // home, menu, details, cart, orders, profile, confirm
  const [cart, setCart] = useState(() => {
    try { return JSON.parse(localStorage.getItem('sd_cart')) || [] } catch { return [] }
  })
  const [orders, setOrders] = useState(() => {
    try { return JSON.parse(localStorage.getItem('sd_orders')) || [] } catch { return [] }
  })
  const [items] = useState(sampleItems)
  const [selectedItem, setSelectedItem] = useState(null)
  const [lastPlacedOrder, setLastPlacedOrder] = useState(null)

  useEffect(()=> { localStorage.setItem('sd_cart', JSON.stringify(cart)) }, [cart])
  useEffect(()=> { localStorage.setItem('sd_orders', JSON.stringify(orders)) }, [orders])

  function addToCart(item){
    setCart(prev=>{
      const existing = prev.find(p => p.id === item.id)
      if(existing){
        return prev.map(p => p.id === item.id ? {...p, qty: p.qty + 1} : p)
      } else {
        return [...prev, {...item, qty:1}]
      }
    })
  }

  function updateCart(updated){
    setCart(updated)
  }

  function openDetails(item){
    setSelectedItem(item)
    setRoute('details')
  }

  function placeDemoOrder(order){
    // add order to orders list
    setOrders(prev => [order, ...prev])
    // clear cart
    setCart([])
    setLastPlacedOrder(order)
    // go to confirmation screen
    setRoute('confirm')
  }

  return (
    <>
      {route === 'home' && <Home items={items} onAdd={addToCart} onOpenMenu={()=>setRoute('menu')} onOpenDetails={openDetails} />}
      {route === 'menu' && <Menu items={items} onAdd={addToCart} onBack={()=>setRoute('home')} onOpenDetails={openDetails} />}
      {route === 'details' && selectedItem && <FoodDetails item={selectedItem} onAdd={(it)=>{ addToCart(it); setRoute('cart') }} onBack={()=>setRoute('menu')} />}
      {route === 'cart' && <Cart cart={cart} updateCart={updateCart} onPlaceOrder={placeDemoOrder} onBack={()=>setRoute('menu')} />}
      {route === 'confirm' && lastPlacedOrder && <OrderConfirmation order={lastPlacedOrder} onDone={()=>setRoute('orders')} />}
      {route === 'orders' && <Orders orders={orders} setOrders={setOrders} />}
      {route === 'profile' && <Profile onPlaceDemoOrder={placeDemoOrder} setRoute={setRoute} />}
      <BottomNav current={route} onChange={setRoute} cartCount={cart.reduce((s,c)=>s+c.qty,0)} />
    </>
  )
}
JS

# src/styles.css
cat > src/styles.css <<'CSS'
:root{
  --bg: #f6f7fb;
  --primary: #0ea5a4; /* teal */
  --accent: #ef4444; /* red */
  --muted: #6b7280;
  --card: #ffffff;
  --phone-w: 390px;
  --phone-h: 844px;
  --radius: 16px;
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
}

body {
  margin: 0;
  min-height: 100vh;
  display: grid;
  place-items: center;
  background: linear-gradient(180deg,#eef2ff, #f6f7fb);
  -webkit-font-smoothing:antialiased;
  -moz-osx-font-smoothing:grayscale;
}

.app-phone {
  width: var(--phone-w);
  height: var(--phone-h);
  border-radius: 32px;
  box-shadow: 0 20px 40px rgba(17,24,39,0.15);
  overflow: hidden;
  background: linear-gradient(180deg, var(--card), #fbfdff);
  display: flex;
  flex-direction: column;
  position: relative;
}

.app-topbar {
  height: 30px;
  background: transparent;
}

.app-main {
  padding: 14px;
  padding-bottom: 80px; /* for bottom nav */
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}

/* header */
.brand {
  display:flex;
  align-items:center;
  gap:10px;
  margin-bottom:8px;
}
.logo {
  display:flex;
  align-items:center;
  gap:8px;
  font-weight:700;
  font-size:18px;
}
.logo .emoji {
  font-size:18px;
}
.subtle {
  color:var(--muted);
  font-size:12px;
}

/* search */
.search {
  margin-top:10px;
  display:flex;
  gap:8px;
}
.search input{
  flex:1;
  padding:10px 12px;
  border-radius:12px;
  border: 1px solid #e6e9ef;
  background: #fff;
  font-size:14px;
}

/* sections */
.section-title {
  display:flex;
  justify-content:space-between;
  align-items:center;
  margin:14px 0 8px 0;
  font-weight:600;
}
.cards {
  display:flex;
  gap:10px;
  overflow-x:auto;
  padding-bottom:6px;
}
.card {
  min-width:160px;
  background:var(--card);
  border-radius:12px;
  padding:10px;
  box-shadow: 0 6px 12px rgba(15,23,42,0.05);
  display:flex;
  flex-direction:column;
  gap:8px;
}
.food-img{
  width:100%;
  height:96px;
  border-radius:8px;
  background:linear-gradient(135deg,#ffe7c7, #fed7aa);
  display:grid;
  place-items:center;
  font-size:38px;
}
.food-name { font-weight:600; font-size:14px; }
.food-meta { display:flex; justify-content:space-between; align-items:center; font-size:13px; color:var(--muted); }

/* add button */
.btn {
  background:var(--primary);
  color:white;
  padding:8px 12px;
  border-radius:10px;
  border:0;
  font-weight:600;
  font-size:14px;
  cursor:pointer;
  transition:transform .12s;
}
.btn:active{ transform:scale(.98); }
.btn-ghost {
  background:transparent;
  border:1px solid #e6e9ef;
  color:var(--muted);
}

/* bottom nav */
.bottom-nav {
  position:absolute;
  bottom:12px;
  left:50%;
  transform:translateX(-50%);
  width:360px;
  height:56px;
  background:linear-gradient(180deg,#fff,#f8fafc);
  border-radius:14px;
  display:flex;
  justify-content:space-around;
  align-items:center;
  box-shadow: 0 8px 20px rgba(15,23,42,0.08);
}

/* list and food rows */
.food-row {
  display:flex;
  gap:10px;
  align-items:center;
  padding:10px 0;
  border-bottom:1px dashed #f1f5f9;
}
.food-row .thumb {
  width:64px;
  height:64px;
  border-radius:10px;
  background:linear-gradient(135deg,#fff3cd,#fff6e5);
  display:grid;
  place-items:center;
  font-size:26px;
}
.row-main { flex:1; }
.price { font-weight:700; color:#111827; }

/* cart sheet */
.cart {
  background:linear-gradient(180deg,#ffffff,#fbfbff);
  padding:12px;
  border-radius:12px;
  box-shadow:0 10px 20px rgba(2,6,23,0.06);
}

/* order confirmed */
.order-card {
  text-align:center;
  padding:18px;
  border-radius:12px;
  background:linear-gradient(180deg,#f3fff9,#ffffff);
}
.qr {
  margin:14px auto;
  width:200px;
  height:200px;
  background:white;
  display:grid;
  place-items:center;
  border-radius:12px;
  box-shadow: 0 10px 30px rgba(2,6,23,0.08);
  font-size:12px;
  color:#111827;
  text-align:center;
}

/* small utilities */
.kv { font-weight:600; color:#374151; }
.muted { color:var(--muted); font-size:13px; }
.tag-veg { background:#dcfce7; color:#065f46; padding:2px 6px; border-radius:6px; font-weight:600; font-size:12px; }

/* feedback */
textarea { width:100%; min-height:86px; padding:10px; border-radius:10px; border:1px solid #e6e9ef; }

/* animations */
.pulse {
  animation: pulse 1.6s infinite;
}
@keyframes pulse {
  0% { transform:scale(1); opacity:1; }
  50% { transform:scale(1.02); opacity:.9; }
  100% { transform:scale(1); opacity:1; }
}

@media (max-width:420px){
  :root{ --phone-w: 360px; }
  .app-phone { width: var(--phone-w); }
  .bottom-nav { width: calc(var(--phone-w) - 30px); }
}
CSS

# src/data/items.js
cat > src/data/items.js <<'JS'
const items = [
  { id: 'm1', name: 'Masala Dosa', price: 70, rating: 4.6, veg:true, emoji:'🥞', desc: 'Crispy dosa served with sambar and chutney.' },
  { id: 'm2', name: 'Paneer Wrap', price: 95, rating: 4.4, veg:true, emoji:'🌯', desc: 'Grilled paneer with fresh veggies and sauces.' },
  { id: 'm3', name: 'Veg Sandwich', price: 55, rating: 4.2, veg:true, emoji:'🥪', desc: 'Toasted sandwich with veggies and cheese.' },
  { id: 'm4', name: 'Margherita Pizza', price: 120, rating: 4.1, veg:true, emoji:'🍕', desc: 'Classic cheese pizza with tomato base.' },
  { id: 'm5', name: 'Samosa (2pc)', price: 30, rating: 4.3, veg:true, emoji:'🥟', desc: 'Crispy samosas stuffed with spiced potatoes.' },
  { id: 'm6', name: 'Cold Coffee', price: 80, rating: 4.5, veg:false, emoji:'🥤', desc: 'Chilled coffee with ice cream and chocolate.' },
  { id: 'm7', name: 'Idli (3pc)', price: 40, rating: 4.0, veg:true, emoji:'🍚', desc: 'Soft steamed idlis with sambhar.' },
  { id: 'm8', name: 'Veg Biryani', price: 130, rating: 4.7, veg:true, emoji:'🍛', desc: 'Aromatic vegetable biryani with raita.' }
]

export default items
JS

# src/utils/helpers.js
cat > src/utils/helpers.js <<'JS'
export function generateOrderId(){
  const n = Math.floor(1000 + Math.random()*9000)
  return `#SD${n}`
}

export function nowPlusMinutes(m){
  const dt = new Date(Date.now() + m*60000)
  const h = dt.getHours()
  const mm = dt.getMinutes().toString().padStart(2,'0')
  const suffix = h >= 12 ? 'PM' : 'AM'
  let hh = h % 12
  if(hh===0) hh = 12
  return `${hh}:${mm} ${suffix}`
}

export function generateSampleOrder(){
  const id = '#SD1024'
  const now = Date.now()
  return {
    id,
    items: [
      { id:'m1', name:'Masala Dosa', price:70, qty:1, emoji:'🥞' },
      { id:'m6', name:'Cold Coffee', price:80, qty:1, emoji:'🥤' }
    ],
    total: 150,
    pickupTime: nowPlusMinutes(15),
    pickupLocation: 'Main Campus Canteen',
    student: { name:'Sample Student', id:'S123456' },
    statusHistory: [
      { key:'placed', label:'Order Placed', ts: now },
      { key:'paid', label:'Payment Confirmed', ts: now }
    ],
    status: 'paid'
  }
}
JS

# src/components/Header.jsx
cat > src/components/Header.jsx <<'JS'
import React from 'react'

export default function Header({onDemo}){
  return (
    <div>
      <div className="brand">
        <div className="logo">
          <span className="emoji">🍽️</span>
          <span>SMART DINE</span>
        </div>
        <div style={{marginLeft:'auto'}} className="subtle">IAR University</div>
      </div>
      <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
        <div className="muted">Main Campus Canteen</div>
        <button className="btn btn-ghost" onClick={onDemo}>Presentation Demo</button>
      </div>
      <div style={{marginTop:10}} className="search">
        <input placeholder="Search food (e.g. Dosa, Coffee)" />
      </div>
    </div>
  )
}
JS

# src/components/FoodCard.jsx
cat > src/components/FoodCard.jsx <<'JS'
import React from 'react'

export default function FoodCard({item, onAdd, onOpenDetails}){
  return (
    <div className="card" role="listitem">
      <div className="food-img" onClick={onOpenDetails} style={{cursor:'pointer'}}>{item.emoji}</div>
      <div className="food-name">{item.name}</div>
      <div className="food-meta">
        <div>
          <span className="tag-veg">{item.veg ? 'VEG' : 'NON-VEG'}</span>
        </div>
        <div className="muted">{item.rating} ★</div>
      </div>
      <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
        <div style={{fontWeight:700}}>₹{item.price}</div>
        <button className="btn" onClick={onAdd}>Add</button>
      </div>
    </div>
  )
}
JS

# src/components/Home.jsx
cat > src/components/Home.jsx <<'JS'
import React from 'react'
import Header from './Header'
import FoodCard from './FoodCard'

export default function Home({items, onAdd, onOpenMenu, onOpenDetails}){
  const specials = items.slice(0,4)
  const popular = items.slice(0,4)
  return (
    <div>
      <Header onDemo={()=>{
        alert('Open Profile → Presentation Demo to run a full presentation flow.')
      }} />
      <div style={{marginTop:12}}>
        <div style={{display:'flex', justifyContent:'space-between', alignItems:'center'}}>
          <div className="section-title">Today's Special</div>
          <div className="subtle" style={{fontSize:12, cursor:'pointer'}} onClick={onOpenMenu}>See all</div>
        </div>
        <div className="cards" role="list">
          {specials.map(it => <FoodCard key={it.id} item={it} onAdd={()=>onAdd(it)} onOpenDetails={()=>onOpenDetails(it)} />)}
        </div>

        <div style={{display:'flex', justifyContent:'space-between', alignItems:'center', marginTop:10}}>
          <div className="section-title">Popular Items</div>
          <div className="subtle">Trending</div>
        </div>
        <div className="cards">
          {popular.map(it => <FoodCard key={it.id} item={it} onAdd={()=>onAdd(it)} onOpenDetails={()=>onOpenDetails(it)} />)}
        </div>

        <div style={{display:'flex', justifyContent:'space-between', alignItems:'center', marginTop:12}}>
          <div className="section-title">Categories</div>
          <div className="subtle">Breakfast • Snacks • Lunch • Beverages</div>
        </div>

        <div style={{marginTop:8}}>
          <div style={{display:'grid', gap:8}}>
            {items.map(it => (
              <div className="food-row" key={it.id}>
                <div className="thumb" onClick={()=>onOpenDetails(it)} style={{cursor:'pointer'}}>{it.emoji}</div>
                <div className="row-main">
                  <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
                    <div>
                      <div style={{fontWeight:700}}>{it.name}</div>
                      <div className="muted" style={{fontSize:12}}>{it.rating} ★ • {it.veg ? 'Veg' : 'Non-Veg'}</div>
                    </div>
                    <div style={{textAlign:'right'}}>
                      <div className="price">₹{it.price}</div>
                      <button className="btn" style={{marginTop:8}} onClick={()=>onAdd(it)}>Add</button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

      </div>
    </div>
  )
}
JS

# src/components/Menu.jsx
cat > src/components/Menu.jsx <<'JS'
import React from 'react'
import FoodCard from './FoodCard'

export default function Menu({items, onAdd, onBack, onOpenDetails}){
  return (
    <div>
      <div style={{display:'flex',alignItems:'center',gap:10}}>
        <button className="btn btn-ghost" onClick={onBack}>← Back</button>
        <div style={{fontWeight:700, fontSize:18}}>Menu</div>
      </div>
      <div style={{marginTop:10}}>
        <div className="cards" style={{flexWrap:'nowrap'}}>
          {items.slice(0,3).map(it => <FoodCard key={it.id} item={it} onAdd={()=>onAdd(it)} onOpenDetails={()=>onOpenDetails(it)} />)}
        </div>
        <div style={{marginTop:10}}>
          {items.map(it => (
            <div className="food-row" key={it.id}>
              <div className="thumb" onClick={()=>onOpenDetails(it)} style={{cursor:'pointer'}}>{it.emoji}</div>
              <div className="row-main">
                <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
                  <div>
                    <div style={{fontWeight:700}}>{it.name}</div>
                    <div className="muted">{it.rating} ★</div>
                  </div>
                  <div style={{textAlign:'right'}}>
                    <div className="price">₹{it.price}</div>
                    <button className="btn" style={{marginTop:8}} onClick={()=>onAdd(it)}>Add</button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
JS

# src/components/FoodDetails.jsx
cat > src/components/FoodDetails.jsx <<'JS'
import React from 'react'

export default function FoodDetails({item, onAdd, onBack}){
  return (
    <div>
      <div style={{display:'flex',alignItems:'center',gap:10}}>
        <button className="btn btn-ghost" onClick={onBack}>← Back</button>
        <div style={{fontWeight:700, fontSize:18}}>Food Details</div>
      </div>

      <div style={{marginTop:12}}>
        <div style={{display:'grid',gap:12}}>
          <div style={{width:'100%',height:200,borderRadius:12,display:'grid',placeItems:'center',fontSize:56,background:'linear-gradient(135deg,#fff3cd,#fff6e5)'}}>{item.emoji}</div>
          <div>
            <div style={{fontWeight:800,fontSize:20}}>{item.name}</div>
            <div className="muted" style={{marginTop:6}}>{item.desc}</div>
            <div style={{display:'flex',gap:8,marginTop:8,alignItems:'center'}}>
              <div className="tag-veg">{item.veg ? 'VEG' : 'NON-VEG'}</div>
              <div className="muted">{item.rating} ★</div>
            </div>
          </div>

          <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
            <div>
              <div className="muted">Price</div>
              <div className="price">₹{item.price}</div>
            </div>
            <div>
              <button className="btn" onClick={()=>onAdd(item)}>Add to Cart</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
JS

# src/components/Cart.jsx
cat > src/components/Cart.jsx <<'JS'
import React, { useState } from 'react'
import { generateOrderId, nowPlusMinutes } from '../utils/helpers'

export default function Cart({cart, updateCart, onPlaceOrder, onBack}) {
  const [pickup, setPickup] = useState(nowPlusMinutes(15))
  const [studentName, setStudentName] = useState('Student A')
  const [studentId, setStudentId] = useState('S123456')

  const total = cart.reduce((s,i)=>s+(i.price * i.qty),0)

  function changeQty(id, delta){
    const updated = cart.map(c => c.id === id ? {...c, qty: Math.max(0, c.qty + delta)} : c ).filter(c=>c.qty>0)
    updateCart(updated)
  }

  function doDemoPayment(){
    const orderId = generateOrderId()
    const pickupTime = pickup
    const order = {
      id: orderId,
      items: cart,
      total,
      pickupTime,
      pickupLocation: 'Main Campus Canteen',
      student: { name: studentName, id: studentId },
      statusHistory: [
        { key:'placed', label:'Order Placed', ts: Date.now() },
        { key:'paid', label:'Payment Confirmed', ts: Date.now() }
      ],
      status: 'paid'
    }

    // simulate payment delay
    setTimeout(()=> onPlaceOrder(order), 900)
  }

  return (
    <div>
      <div style={{display:'flex',alignItems:'center',gap:10}}>
        <button className="btn btn-ghost" onClick={onBack}>← Back</button>
        <div style={{fontWeight:700, fontSize:18}}>Cart</div>
      </div>
      <div style={{marginTop:10}}>
        {cart.length === 0 ? (
          <div className="muted">Your cart is empty. Add items from the menu.</div>
        ) : (
          <div className="cart">
            {cart.map(it => (
              <div key={it.id} style={{display:'flex',alignItems:'center',gap:10,marginBottom:8}}>
                <div style={{width:56,height:56,borderRadius:8,background:'#fff',display:'grid',placeItems:'center',fontSize:22}}>{it.emoji}</div>
                <div style={{flex:1}}>
                  <div style={{fontWeight:700}}>{it.name}</div>
                  <div className="muted">₹{it.price} • Qty: {it.qty}</div>
                </div>
                <div style={{display:'flex',flexDirection:'column',gap:6,alignItems:'flex-end'}}>
                  <div className="price">₹{it.price * it.qty}</div>
                  <div style={{display:'flex',gap:6}}>
                    <button className="btn btn-ghost" onClick={()=>changeQty(it.id,-1)}>-</button>
                    <button className="btn btn-ghost" onClick={()=>changeQty(it.id,1)}>+</button>
                  </div>
                </div>
              </div>
            ))}

            <div style={{marginTop:8}}>
              <div className="kv">Pickup Slot</div>
              <div style={{display:'flex',gap:8,marginTop:8}}>
                <button className="btn btn-ghost" onClick={()=>setPickup(nowPlusMinutes(10))}>{nowPlusMinutes(10)}</button>
                <button className="btn btn-ghost" onClick={()=>setPickup(nowPlusMinutes(20))}>{nowPlusMinutes(20)}</button>
                <button className="btn btn-ghost" onClick={()=>setPickup(nowPlusMinutes(30))}>{nowPlusMinutes(30)}</button>
              </div>

              <div style={{marginTop:10}}>
                <div className="kv">Student</div>
                <input value={studentName} onChange={e=>setStudentName(e.target.value)} style={{marginTop:6, padding:10, borderRadius:8, border:'1px solid #e6e9ef', width:'100%'}} />
                <input value={studentId} onChange={e=>setStudentId(e.target.value)} style={{marginTop:6, padding:10, borderRadius:8, border:'1px solid #e6e9ef', width:'100%'}} />
              </div>

              <div style={{marginTop:12, display:'flex', justifyContent:'space-between', alignItems:'center'}}>
                <div>
                  <div className="muted">Total</div>
                  <div className="price">₹{total}</div>
                </div>
                <div>
                  <button className="btn" onClick={doDemoPayment}>Demo Payment</button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
JS

# src/components/Orders.jsx
cat > src/components/Orders.jsx <<'JS'
import React, { useEffect, useState } from 'react'
import QRBlock from './QRBlock'
import Feedback from './Feedback'

export default function Orders({orders, setOrders}){
  const [selected, setSelected] = useState(null)
  const [showFeedbackFor, setShowFeedbackFor] = useState(null)

  useEffect(()=>{
    // auto-progress statuses for recent demo orders (simulate)
    const timers = []
    orders.forEach((order, idx) => {
      if(order.status === 'paid'){
        // after 3s -> preparing
        timers.push(setTimeout(()=> {
          updateOrderStatus(order.id, 'preparing', 'Preparing')
        }, 3000 + idx*400))
        // after 8s -> ready
        timers.push(setTimeout(()=> {
          updateOrderStatus(order.id, 'ready', 'Ready for Pickup')
        }, 8000 + idx*700))
      }
    })
    return ()=> timers.forEach(t=>clearTimeout(t))
    // eslint-disable-next-line
  }, [orders])

  function updateOrderStatus(id, key, label){
    setOrders(prev => prev.map(o => {
      if(o.id !== id) return o
      const next = {...o}
      next.status = key
      next.statusHistory = [...next.statusHistory, { key, label, ts: Date.now() }]
      return next
    }))
  }

  function openOrder(o){
    setSelected(o)
  }

  function onSubmitFeedback(orderId, payload){
    // for demo just show alert and close feedback
    alert('Thanks for your feedback!')
    setShowFeedbackFor(null)
  }

  return (
    <div>
      <div style={{display:'flex',alignItems:'center',gap:10}}>
        <div style={{fontWeight:700, fontSize:18}}>Orders</div>
      </div>
      <div style={{marginTop:10}}>
        {orders.length === 0 ? <div className="muted">No recent orders yet. Place a demo order to see the flow.</div> :
          orders.map(o => (
            <div key={o.id} style={{marginBottom:12, padding:12, borderRadius:10, background:'#fff'}} onClick={()=>openOrder(o)}>
              <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
                <div>
                  <div style={{fontWeight:700}}>{o.id}</div>
                  <div className="muted">{o.pickupLocation} • {o.pickupTime}</div>
                </div>
                <div style={{textAlign:'right'}}>
                  <div className="muted">{o.status === 'ready' ? '🎉 Ready' : o.status === 'preparing' ? '● Preparing' : '✓ '+o.status}</div>
                  <div style={{fontWeight:700}}>₹{o.total}</div>
                </div>
              </div>
            </div>
          ))
        }
      </div>

      {selected && (
        <div style={{marginTop:12}}>
          <div className="order-card">
            <div style={{fontSize:18, fontWeight:800}}>Order {selected.id}</div>
            <div className="muted" style={{marginTop:8}}>Pickup: {selected.pickupTime} • {selected.pickupLocation}</div>

            <div style={{textAlign:'left', marginTop:12}}>
              {selected.items.map(i => (
                <div key={i.id} style={{display:'flex',justifyContent:'space-between',padding:'6px 0', borderBottom:'1px dashed #f1f5f9'}}>
                  <div>{i.name} × {i.qty}</div>
                  <div>₹{i.price * i.qty}</div>
                </div>
              ))}
            </div>

            <div style={{marginTop:12}}>
              <div className="kv">Status</div>
              <div style={{marginTop:8}}>
                {selected.statusHistory.map((s,idx)=>(
                  <div key={idx} style={{display:'flex',alignItems:'center',gap:8, padding:'6px 0'}}>
                    <div style={{width:10,height:10, borderRadius:20, background: s.key === 'ready' ? '#10b981' : s.key === 'preparing' ? '#f59e0b' : '#4f46e5'}} />
                    <div style={{flex:1}}>{s.label}</div>
                    <div className="muted" style={{fontSize:12}}>{new Date(s.ts).toLocaleTimeString()}</div>
                  </div>
                ))}
              </div>
            </div>

            <div style={{marginTop:12}}>
              <QRBlock orderId={selected.id} />
              {selected.status === 'ready' && <div style={{marginTop:10, fontWeight:700}}>Please collect your order from Counter 2.</div>}
            </div>

            <div style={{marginTop:12, display:'flex', gap:8, justifyContent:'center'}}>
              <button className="btn" onClick={()=>{ setSelected(null) }}>Close</button>
              <button className="btn btn-ghost" onClick={()=>setShowFeedbackFor(selected.id)}>Feedback</button>
            </div>

            {showFeedbackFor === selected.id && (
              <div style={{marginTop:12}}>
                <Feedback onSubmit={(p)=>onSubmitFeedback(selected.id, p)} />
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
JS

# src/components/QRBlock.jsx
cat > src/components/QRBlock.jsx <<'JS'
import React from 'react'

export default function QRBlock({orderId}){
  // Simple QR-like visual (demo)
  return (
    <div style={{display:'flex',flexDirection:'column',alignItems:'center',gap:8, marginTop:8}}>
      <div className="qr">
        <svg width="150" height="150" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
          <rect x="0" y="0" width="28" height="28" fill="#111827" />
          <rect x="72" y="0" width="28" height="28" fill="#111827" />
          <rect x="0" y="72" width="28" height="28" fill="#111827" />
          {/* inner pattern */}
          <rect x="40" y="40" width="8" height="8" fill="#111827"/>
          <rect x="52" y="52" width="6" height="6" fill="#111827"/>
          <rect x="24" y="52" width="6" height="6" fill="#111827"/>
          <rect x="52" y="24" width="6" height="6" fill="#111827"/>
        </svg>
      </div>
      <div style={{fontWeight:700}}>SCAN AT CANTEEN</div>
      <div className="muted">Show this QR code at the pickup counter.</div>
    </div>
  )
}
JS

# src/components/Profile.jsx
cat > src/components/Profile.jsx <<'JS'
import React from 'react'
import { generateSampleOrder } from '../utils/helpers'

export default function Profile({onPlaceDemoOrder, setRoute}){
  function runPresentationDemo(){
    const sample = generateSampleOrder()
    onPlaceDemoOrder(sample)
    setRoute('orders')
  }

  return (
    <div>
      <div style={{display:'flex',alignItems:'center',gap:10}}>
        <div style={{width:64,height:64, borderRadius:12, background:'#fff', display:'grid',placeItems:'center', fontSize:28}}>👩‍🎓</div>
        <div>
          <div style={{fontWeight:800}}>Sample Student</div>
          <div className="muted">S123456 • IAR University</div>
        </div>
      </div>

      <div style={{marginTop:12}}>
        <div className="kv">Presentation Demo</div>
        <div className="muted" style={{marginTop:6}}>Run the full demonstration flow with sample data and automatic order progressions.</div>
        <div style={{marginTop:10}}>
          <button className="btn pulse" onClick={runPresentationDemo}>Run Presentation Demo</button>
        </div>
      </div>

      <div style={{marginTop:18}}>
        <div className="kv">About SMART DINE</div>
        <div className="muted" style={{marginTop:6}}>Digital Menu • Zero Queue • Happy You!</div>
      </div>
    </div>
  )
}
JS

# src/components/BottomNav.jsx
cat > src/components/BottomNav.jsx <<'JS'
import React from 'react'

export default function BottomNav({current, onChange, cartCount}){
  const items = [
    { key:'home', label:'🏠 Home' },
    { key:'menu', label:'🍴 Menu' },
    { key:'cart', label:`🛒 Cart${cartCount? ' ('+cartCount+')':''}` },
    { key:'orders', label:'📦 Orders' },
    { key:'profile', label:'👤 Profile' }
  ]
  return (
    <div className="bottom-nav" role="navigation" aria-label="Main">
      {items.map(i => (
        <button key={i.key} onClick={()=>onChange(i.key)} style={{background:'transparent',border:0,fontWeight: current===i.key?800:600}}>{i.label}</button>
      ))}
    </div>
  )
}
JS

# src/components/OrderConfirmation.jsx
cat > src/components/OrderConfirmation.jsx <<'JS'
import React, { useState } from 'react'

export default function OrderConfirmation({order, onDone}){
  const [copied, setCopied] = useState(false)

  function copyId(){
    try{ navigator.clipboard.writeText(order.id); setCopied(true); setTimeout(()=>setCopied(false),1500) }catch{}
  }

  return (
    <div>
      <div style={{display:'flex',alignItems:'center',gap:10}}>
        <div style={{fontWeight:700, fontSize:18}}>Order Confirmed</div>
      </div>

      <div style={{marginTop:12}}>
        <div className="order-card">
          <div style={{fontSize:20, fontWeight:800}}>🎉 Order Confirmed!</div>
          <div className="muted" style={{marginTop:8}}>Order ID:</div>
          <div style={{fontWeight:800, marginTop:6}}>{order.id}</div>

          <div style={{display:'flex',justifyContent:'space-between',marginTop:10}}>
            <div>
              <div className="muted">Pickup Time</div>
              <div className="kv">{order.pickupTime}</div>
            </div>
            <div>
              <div className="muted">Pickup Location</div>
              <div className="kv">{order.pickupLocation}</div>
            </div>
          </div>

          <div style={{marginTop:12}}>
            <div className="kv">Scan to pickup</div>
            <div style={{marginTop:8}}>
              <div style={{display:'flex',justifyContent:'center'}}>
                <div className="qr">
                  <svg width="150" height="150" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <rect x="0" y="0" width="28" height="28" fill="#111827" />
                    <rect x="72" y="0" width="28" height="28" fill="#111827" />
                    <rect x="0" y="72" width="28" height="28" fill="#111827" />
                    <rect x="40" y="40" width="8" height="8" fill="#111827"/>
                    <rect x="52" y="52" width="6" height="6" fill="#111827"/>
                    <rect x="24" y="52" width="6" height="6" fill="#111827"/>
                    <rect x="52" y="24" width="6" height="6" fill="#111827"/>
                  </svg>
                </div>
              </div>
            </div>

            <div className="muted" style={{marginTop:10}}>Show this QR code at the pickup counter.</div>

            <div style={{marginTop:12, display:'flex', gap:8, justifyContent:'center'}}>
              <button className="btn btn-ghost" onClick={copyId}>{copied ? 'Copied' : 'Copy Order ID'}</button>
              <button className="btn" onClick={onDone}>Done</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
JS

# src/components/Feedback.jsx
cat > src/components/Feedback.jsx <<'JS'
import React, { useState } from 'react'

export default function Feedback({onSubmit}){
  const [text, setText] = useState('')
  const [rating, setRating] = useState(5)

  function submit(){
    onSubmit({rating, text});
    setText('')
    setRating(5)
    alert('Thank you for your feedback!')
  }

  return (
    <div style={{marginTop:12}}>
      <div className="kv">Feedback</div>
      <div className="muted" style={{marginTop:6}}>Tell us about your experience.</div>
      <div style={{marginTop:8}}>
        <div style={{display:'flex',gap:8}}>
          {[1,2,3,4,5].map(n=> (
            <button key={n} className="btn btn-ghost" onClick={()=>setRating(n)} style={{background: rating===n ? 'var(--primary)' : 'transparent', color: rating===n ? 'white' : 'inherit'}}>{n}★</button>
          ))}
        </div>
        <div style={{marginTop:8}}>
          <textarea value={text} onChange={e=>setText(e.target.value)} placeholder="Share your thoughts..." />
        </div>
        <div style={{marginTop:8}}>
          <button className="btn" onClick={submit}>Submit Feedback</button>
        </div>
      </div>
    </div>
  )
}
JS

# GitHub Actions workflow: build & deploy to gh-pages
cat > .github/workflows/gh-pages-deploy.yml <<'YML'
name: Deploy SMART DINE to GitHub Pages
on:
  push:
    branches:
      - smart-dine-prototype

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Use Node.js 18
        uses: actions/setup-node@v4
        with:
          node-version: 18

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Deploy to gh-pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
YML

# README
cat > README.md <<'MD'
# SMART DINE — Mobile Canteen Ordering Prototype

Tagline: Digital Menu • Zero Queue • Happy You!

This repository is a mobile-first React + Vite prototype for a college canteen ordering system called SMART DINE. It is a demonstration/prototype only — no real payments, no authentication, and no backend.

Designed for a phone-sized canvas: 390 × 844 px. On desktop the app is centered in a phone-like frame.

Features:
- Browse menu, add to cart.
- Choose pickup slot, demo payment (simulated).
- Order confirmation with QR-style visual.
- Order tracking with automatic status progression (for demo).
- Presentation Demo mode that runs a sample order using sample student data.
- Mobile-first styling, animations, and reusable components.
- Ready for local testing and for deployment to GitHub Pages.

Getting started (local):

1. Install
   - Node 18+ recommended.
   - Install dependencies:
     npm ci

2. Run dev server:
     npm run dev
   Open the URL printed by Vite (the app is optimized for mobile view; the desktop browser will show the phone shell).

3. Build:
     npm run build

4. Preview build:
     npm run preview

Deploy to GitHub Pages:
- This project uses an Actions workflow to deploy the `dist/` folder to the `gh-pages` branch automatically when you push the `smart-dine-prototype` branch.
- After you push `smart-dine-prototype`, open the Actions tab and watch the "Deploy SMART DINE to GitHub Pages" workflow. When it finishes, the site will be available at:
  https://hp6521007-droid.github.io/smart-dine/

Presentation Demo:
- Open the Profile tab and click "Run Presentation Demo". This instantly creates a sample order (#SD1024) and navigates to Orders. Status will auto-progress (Payment Confirmed → Preparing → Ready for Pickup) so you can demo the whole flow.

Branding:
- The app consistently uses "SMART DINE". Do not use "Campus Eats" anywhere.

Important notes:
- This is a prototype for college demonstration only.
- No real payment gateway is used.
- The QR shown is a demo/visual only.

If you want, I can:
- Verify the pushed GitHub Actions run and confirm the GitHub Pages URL,
- Or create a pull request instead of pushing directly.
MD

# .gitignore
cat > .gitignore <<'TXT'
node_modules
dist
.env
.DS_Store
TXT

echo "All files created."
echo "Next steps:"
echo "  1) npm ci"
echo "  2) git add . && git commit -m \"feat: add SMART DINE prototype (complete)\""
echo "  3) git push --set-upstream origin smart-dine-prototype"
echo ""
echo "After pushing, check Actions → 'Deploy SMART DINE to GitHub Pages'. When it completes the site will be published to:"
echo "  https://hp6521007-droid.github.io/smart-dine/"

echo "Done."