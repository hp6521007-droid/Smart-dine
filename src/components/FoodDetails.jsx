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
