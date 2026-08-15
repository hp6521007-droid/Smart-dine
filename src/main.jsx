import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './styles.css'

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <div className="app-phone">
      <div className="app-topbar" />
      <div className="app-main">
        <App />
      </div>
    </div>
  </React.StrictMode>
)
