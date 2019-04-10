'use strict';

const content = `
<\!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
  </head>
  <body></body>
</html>
`;

const botUserAgents = ['Twitterbot', 'facebookexternalhit'];

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;

    if (request.uri !== '/hogehoge') {
        callback(null, request);

        return;
    }

    const userAgent = request.headers['user-agent'][0].value;
    const isBot = botUserAgents.some(botUserAgent => {
        return userAgent.includes(botUserAgent)
    });

    if (isBot) {
        const response = {
            status: '200',
            statusDescription: 'OK',
            headers: {
                'content-type': [{
                    key: 'Content-Type',
                    value: 'text/html'
                }],
                'content-encoding': [{
                    key: 'Content-Encoding',
                    value: 'UTF-8'
                }],
            },
            body: content,
        };
        callback(null, response);
        return;
    }

    callback(null, request);
};