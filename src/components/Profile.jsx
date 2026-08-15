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
          <div style={{fontWeight:800}}>Harsh, Devansh, Dhruvi</div>
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
