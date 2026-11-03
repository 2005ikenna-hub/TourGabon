CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL DEFAULT 'tourist',
    language VARCHAR(10) NOT NULL DEFAULT 'fr',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sites (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(160) NOT NULL,
    description TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    category VARCHAR(60) NOT NULL,
    address VARCHAR(255),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    site_id INT NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(160) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(60) NOT NULL,
    location VARCHAR(255) NOT NULL,
    latitude REAL,
    longitude REAL,
    starts_at TIMESTAMP NOT NULL,
    ends_at TIMESTAMP,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX sites_category_idx ON sites (category);
CREATE INDEX reviews_site_id_idx ON reviews (site_id);
CREATE INDEX reviews_user_id_idx ON reviews (user_id);
CREATE INDEX events_starts_at_idx ON events (starts_at);
CREATE INDEX events_category_idx ON events (category);
