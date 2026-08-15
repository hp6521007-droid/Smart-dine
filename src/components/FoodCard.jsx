import React from 'react'

export default function FoodCard({ item, onAdd, onOpenDetails }) {
  return (
    <div className="card" role="listitem">
      <div
        className="food-img"
        onClick={() => onOpenDetails(item)}
        style={{ cursor: 'pointer' }}
      >
        {item.image ? (
          <img
            src={item.image}
            alt={item.name}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              borderRadius: '8px',
              display: 'block'
            }}
          />
        ) : (
          <span>No image</span>
        )}
      </div>

      <div className="food-name">{item.name}</div>

      <div className="food-meta">
        <div>
          <span className="tag-veg">
            {item.veg ? 'VEG' : 'NON-VEG'}
          </span>
        </div>

        <div className="muted">
          {item.rating} ★
        </div>
      </div>

      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}
      >
        <div style={{ fontWeight: 700 }}>
          ₹{item.price}
        </div>

        <button className="btn" onClick={() => onAdd(item)}>
          Add
        </button>
      </div>
    </div>
  )
}