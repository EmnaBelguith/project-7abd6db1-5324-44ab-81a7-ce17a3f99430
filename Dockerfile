FROM python:3.10-slim-bullseye
WORKDIR /app/
COPY . /app/
RUN pip install --no-cache-dir -r fastapi_project\requirements.txt
RUN pip install fastapi uvicorn[standard]
EXPOSE 8000
ENV PYTHONUNBUFFERED=1
CMD ["uvicorn", "fastapi_project.main:app", "--host", "0.0.0.0", "--port", "8000", "--log-level", "debug"]
RUN apt-get update && apt-get install -y curl --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN echo "--- Listing /app contents ---"
RUN ls -R /app
RUN echo "--- Verifying Python import ---"
RUN python <<EOF
import os
import sys
print('Current working directory:', os.getcwd())
print('sys.path:', sys.path)
sys.path.insert(0, '/app')
print('Updated sys.path:', sys.path)
try:
    from fastapi_project.main import app
    print('app found and importable!')
except ImportError as e:
    print('ImportError: ' + str(e))
    sys.exit(1)

EOF
RUN echo "--- Python import check complete ---"