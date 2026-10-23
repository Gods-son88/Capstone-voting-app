FROM node:18-slim

# Add curl for healthchecks and tini for safe process lifecycle management
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# Keep nodemon available for local development file watching
RUN npm install -g nodemon

COPY package*.json ./

# Install dependencies cleanly and move them to prevent local bind-mount overwrite issues
RUN npm ci && \
    npm cache clean --force && \
    mv /usr/local/app/node_modules /node_modules

COPY . .

# Grant explicit directory ownership to the pre-existing non-root 'node' user profile
RUN chown -R node:node /usr/local/app /node_modules

# Switch context to the low-privilege user
USER node

ENV PORT=80
EXPOSE 80

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
