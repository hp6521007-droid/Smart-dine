import React from 'react'
import FoodCard from './FoodCard'

export default function Menu({
  items,
  onAdd,
  onRemove,
  getCartQty,
  onBack,
  onOpenDetails
}) {
  return (
    <div>

      {/* Menu header */}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: 10
        }}
      >
        <button
          className="btn btn-ghost"
          onClick={onBack}
        >
          ← Back
        </button>

        <div
          style={{
            fontWeight: 700,
            fontSize: 18
          }}
        >
          Menu
        </div>
      </div>


      {/* Top food cards */}
      <div style={{ marginTop: 10 }}>
        <div
          className="cards"
          style={{ flexWrap: 'nowrap' }}
        >
          {items.slice(0, 3).map(it => (
            <FoodCard
              key={it.id}
              item={it}
              onAdd={onAdd}
              onRemove={onRemove}
              getCartQty={getCartQty}
              onOpenDetails={onOpenDetails}
            />
          ))}
        </div>


        {/* Full menu list */}
        <div style={{ marginTop: 10 }}>

          {items.map(it => (
            <div
              className="food-row"
              key={it.id}
            >

              {/* Image */}
              <div
                className="thumb"
                onClick={() => onOpenDetails(it)}
                style={{ cursor: 'pointer' }}
              >
                <img
                  src={it.image}
                  alt={it.name}
                />
              </div>


              {/* Food information */}
              <div className="row-main">

                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center'
                  }}
                >

                  <div>
                    <div
                      style={{
                        fontWeight: 700
                      }}
                    >
                      {it.name}
                    </div>

                    <div className="muted">
                      {it.rating} ★
                    </div>
                  </div>


                  {/* Price + quantity */}
                  <div
                    style={{
                      textAlign: 'right'
                    }}
                  >

                    <div className="price">
                      ₹{it.price}
                    </div>


                    {getCartQty(it) === 0 ? (

                      <button
                        className="btn"
                        style={{ marginTop: 8 }}
                        onClick={() => onAdd(it)}
                      >
                        +
                      </button>

                    ) : (

                      <div
                        className="qty-control"
                        style={{ marginTop: 8 }}
                      >

                        <button
                          className="qty-btn"
                          onClick={() => onRemove(it)}
                        >
                          −
                        </button>

                        <span className="qty-number">
                          {getCartQty(it)}
                        </span>

                        <button
                          className="qty-btn"
                          onClick={() => onAdd(it)}
                        >
                          +
                        </button>

                      </div>

                    )}

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