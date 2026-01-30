import sequelize from './shared/database/database.js'
import { usersRouter } from "./users/router.js"
import express from 'express'

const app = express()
const PORT = process.env.PORT || 8000

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() })
})

sequelize.sync({ force: false }).then(() => console.log('db is ready'))

app.use(express.json())
app.use('/api/users', usersRouter)

const server = app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`)
})

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully')
    server.close(() => {
        console.log('Process terminated')
        process.exit(0)
    })
})

export { app, server }