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
