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
