import { useEffect, useState } from 'react'
import { Container, Typography, CircularProgress } from '@mui/material'

function App() {
  const [status, setStatus] = useState<string | null>(null)

  useEffect(() => {
    fetch('/api/health')
      .then(res => res.json())
      .then(data => setStatus(data.status))
      .catch(() => setStatus('error'))
  }, [])

  return (
    <Container>
      <Typography variant="h4" gutterBottom>
        Marcus Bike Shop
      </Typography>
      {status ? (
        <Typography>API Health: {status}</Typography>
      ) : (
        <CircularProgress />
      )}
    </Container>
  )
}

export default App
