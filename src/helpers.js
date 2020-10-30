const axios = require('axios').default
const dns = require('dns')

module.exports.ipLookup = (hostname) =>
  new Promise((resolve, reject) => {
    dns.lookup(hostname, (err, address, family) => {
      if (err) {
        reject(err)
      } else {
        resolve({ hostname, address, family })
      }
    })
  })

module.exports.urlLookup = async (url) => {
  let httpResponse
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
  return httpResponse
}
