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
