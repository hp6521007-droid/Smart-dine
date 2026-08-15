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
