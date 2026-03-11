# Python imayji
FROM python:3.12-slim

# Muhit o'zgaruvchilari
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Ishchi katalogni belgilash
WORKDIR /app

# Kutubxonalarni o'rnatish uchun zarur bo'lgan tizim paketlari
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Talablarni ko'chirish va o'rnatish
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Loyiha fayllarini ko'chirish
COPY . .

# Statik fayllarni yig'ish
RUN python manage.py collectstatic --noinput

# Portni ochish (Render odatda $PORT muhit o'zgaruvchisidan foydalanadi)
EXPOSE 8000

# Serverni ishga tushirish (Daphne ishlatiladi - Channels uchun)
CMD daphne -b 0.0.0.0 -p $PORT config.asgi:application
