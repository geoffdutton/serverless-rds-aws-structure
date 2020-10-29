const https = require('https')
const { Client } = require('pg')
const client = new Client()

module.exports.hello = async (event) => {
  const responseHeaders = await new Promise((resolve, reject) => {
    console.log('Testing outbound internet connection')
    const req = https.request(
      'https://www.google.com',
      { method: 'HEAD' },
      (res) => {
        console.log('Success!', res.headers)
        resolve(res.headers)
      }
    )
    req
      .on('timeout', () => {
        console.log('Timeout!!')
        req.abort()
      })
      .on('error', (err) => {
        console.log('Failed!')
        reject(err)
      })
      .end()
  })

  await client.connect()
  const res = await client.query('SELECT $1::text as message', [
    'DB connection success!'
  ])
  const dbResponse = res.rows[0].message
  await client.end()

  return {
    message: 'Very much success!!',
    dbResponse,
    responseHeaders,
    event
  }
}
