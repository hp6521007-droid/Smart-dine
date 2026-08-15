export function generateOrderId(){
  const n = Math.floor(1000 + Math.random()*9000)
  return `#SD${n}`
}

export function nowPlusMinutes(m){
  const dt = new Date(Date.now() + m*60000)
  const h = dt.getHours()
  const mm = dt.getMinutes().toString().padStart(2,'0')
  const suffix = h >= 12 ? 'PM' : 'AM'
  let hh = h % 12
  if(hh===0) hh = 12
  return `${hh}:${mm} ${suffix}`
}

export function generateSampleOrder(){
  const id = '#SD1024'
  const now = Date.now()
  return {
    id,
    items: [
      { id:'m1', name:'Masala Dosa', price:70, qty:1, emoji:'🥞' },
      { id:'m6', name:'Cold Coffee', price:80, qty:1, emoji:'🥤' }
    ],
    total: 150,
    pickupTime: nowPlusMinutes(15),
    pickupLocation: 'Main Campus Canteen',
    student: { name:'Sample Student', id:'S123456' },
    statusHistory: [
      { key:'placed', label:'Order Placed', ts: now },
      { key:'paid', label:'Payment Confirmed', ts: now }
    ],
    status: 'paid'
  }
}
