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
