const axios = require('axios').default
const dns = require('dns')
const { Client } = require('pg')

module.exports.hello = async (event, context) => {
  const dnsResponse = await new Promise((resolve, reject) => {
    const hostname = 'serverless.com'
    dns.lookup(hostname, (err, address, family) => {
      if (err) {
        reject(err)
      } else {
        resolve({ hostname, address, family })
      }
    })
  })

  console.log({ dnsResponse })

  const dbDnsResponse = await new Promise((resolve, reject) => {
    const hostname = process.env.PGHOST
    dns.lookup(hostname, (err, address, family) => {
      if (err) {
        reject(err)
      } else {
        resolve({ hostname, address, family })
      }
    })
  })

  console.log({ dbDnsResponse })

  let httpResponse
  const url = 'https://www.serverless.com'
  try {
    const res = await axios.head(url, {
      timeout: 5000
    })
    httpResponse = `Successful response with status code: ${res.status}, statusText: ${res.statusText}`
  } catch (e) {
    if (e.response) {
      const res = e.response
      console.error('bad response', res.status, res.data, res.headers)
      httpResponse = `Successful response with status code: ${res.status}, statusText: ${res.statusText}`
    } else if (e.request) {
      console.error('No response', url, e)
      httpResponse = `No response from ${url}`
    } else {
      console.error('unknown error', e)
      httpResponse = `Other error: ${e.message}`
    }
  }

  // When client.end() is called, we need to create a new client
  // each invocation
  const client = new Client()
  await client.connect()
  const dbRes = await client.query('SELECT $1::text as message', [
    'DB connection success!'
  ])
  const dbResponse = dbRes.rows[0].message
  await client.end()

  return {
    message: 'Very much success!!',
    dbResponse,
    dnsResponse,
    dbDnsResponse,
    responseHeader: httpResponse,
    event
  }
}
