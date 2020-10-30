const { Client } = require('pg')
const { ipLookup, urlLookup } = require('./helpers')

module.exports.hello = async (event) => {
  console.log('env:', process.env)
  const [dbDnsResponse, dnsResponse] = await Promise.all([
    ipLookup(process.env.PGHOST),
    ipLookup('encrypted.google.com')
  ])

  console.log({ dnsResponse, dbDnsResponse })

  const url = 'https://encrypted.google.com'
  const httpResponse = await urlLookup(url)

  // When client.end() is called, we need to create a new client
  // each invocation
  const client = new Client({
    connectionTimeoutMillis: 10 * 1000,
    query_timeout: 10 * 1000
  })

  let dbResponse
  try {
    await client.connect()
    const dbRes = await client.query('SELECT $1::text as message', [
      'DB connection success!'
    ])
    dbResponse = dbRes.rows[0].message
  } catch (e) {
    dbResponse = `ERROR: ${e.message}`
  } finally {
    await client.end()
  }

  return {
    message: 'Very much success!!!',
    dbResponse,
    dnsResponse,
    dbDnsResponse,
    responseHeader: httpResponse,
    event
  }
}
