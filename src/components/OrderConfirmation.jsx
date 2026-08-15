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
