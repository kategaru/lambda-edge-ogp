There's an issue with how social media crawlers handle Single Page Apps.  
Basically, social media crawlers do not run Javascript when they scrape your site for meta info to use when sharing.  
That is why social media crawlers can not fetch meta information correctly.  
So, this is one of the solutions to set meta information correctly using Lambda@Edge.  

### How To Use
1. Set meta information which you want add to the entire site or specific page between head tag in index.js.
1. Create Lambda function and upload index.js.
1. Deploy to Lambda@Edge.
1. Connect Lambda@Edge to CloudFlont distribution.