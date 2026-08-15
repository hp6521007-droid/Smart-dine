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
