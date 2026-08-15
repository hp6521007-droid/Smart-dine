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
