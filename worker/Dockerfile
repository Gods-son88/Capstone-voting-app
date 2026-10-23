# ==============================================================================
# Stage 1: Isolated Cross-Compilation Build Environment
# ==============================================================================
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

WORKDIR /source
COPY *.csproj .
RUN dotnet restore -a $TARGETARCH

COPY . .
RUN dotnet publish -c release -o /app -a $TARGETARCH --self-contained false --no-restore


# ==============================================================================
# Stage 2: Minimal Secure Runtime Environment
# ==============================================================================
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app

# Copy the compiled binaries cleanly from our build stage
COPY --from=build /app .

# Create a secure, low-privilege application system user inside the runtime image
RUN useradd -u 10002 workeruser && chown -R workeruser:workeruser /app

# Drop root context and enforce standard unprivileged user constraints
USER workeruser

ENTRYPOINT ["dotnet", "Worker.dll"]
