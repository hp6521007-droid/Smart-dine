import React, { useState } from 'react'

export default function Feedback({onSubmit}){
  const [text, setText] = useState('')
  const [rating, setRating] = useState(5)

  function submit(){
    onSubmit({rating, text});
    setText('')
    setRating(5)
    alert('Thank you for your feedback!')
  }

  return (
    <div style={{marginTop:12}}>
      <div className="kv">Feedback</div>
      <div className="muted" style={{marginTop:6}}>Tell us about your experience.</div>
      <div style={{marginTop:8}}>
        <div style={{display:'flex',gap:8}}>
          {[1,2,3,4,5].map(n=> (
            <button key={n} className="btn btn-ghost" onClick={()=>setRating(n)} style={{background: rating===n ? 'var(--primary)' : 'transparent', color: rating===n ? 'white' : 'inherit'}}>{n}★</button>
          ))}
        </div>
        <div style={{marginTop:8}}>
          <textarea value={text} onChange={e=>setText(e.target.value)} placeholder="Share your thoughts..." />
        </div>
        <div style={{marginTop:8}}>
          <button className="btn" onClick={submit}>Submit Feedback</button>
        </div>
      </div>
    </div>
  )
}
