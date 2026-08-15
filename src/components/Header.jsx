import React from 'react'

export default function Header({ onDemo, onMenu }) {
  return (
    <div className="modern-header">

      {/* Top navigation */}
      <div className="header-top">
        <button
          className="icon-button"
          onClick={onMenu}
          aria-label="Open menu"
        >
          <span></span>
          <span></span>
          <span></span>
        </button>

        <button className="heart-button" aria-label="Favorites">
          ♡
        </button>
      </div>

      {/* Center logo */}
      <div className="brand-center">
        <div className="smart-logo">
          <div className="smart-logo-inner">SD</div>
        </div>

        <div className="smart-dine-title">
          <span>SMART</span> DINE
        </div>

        <div className="smart-dine-tagline">
          EAT SMART · LIVE WELL
        </div>
      </div>

      {/* Campus information */}
      <div className="campus-row">
        <div className="campus-name">
          <span className="campus-dot"></span>
          Main Campus Canteen
        </div>

        <div className="university-name">
          IAR University
        </div>
      </div>

      {/* Demo button */}
      <div className="demo-row">
        <button className="btn btn-ghost" onClick={onDemo}>
          ▣ Presentation Demo
        </button>
      </div>

      {/* Search */}
      <div className="search">
        <input placeholder="Search food (e.g. Dosa, Coffee)" />
      </div>

    </div>
  )
}