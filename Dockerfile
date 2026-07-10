FROM node:22-slim

WORKDIR /app

# Copy package.json and install dependencies
COPY website/package.json ./website/
RUN cd website && npm install

# Copy application files
COPY website/ ./website/
COPY data/ ./data-templates/
COPY shared/ ./shared/
COPY scripts/ ./scripts/
COPY start.sh ./
RUN chmod +x start.sh

# Create data directory for volume mount
RUN mkdir -p /data

# Expose port
EXPOSE 3000

# Set environment
ENV DATA_DIR=/data
ENV NODE_ENV=production

# Start the application
CMD ["./start.sh"]
