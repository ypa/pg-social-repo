CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	username VARCHAR(30) NOT NULL,
	bio VARCHAR(400),
	avatar VARCHAR(200),
	phone VARCHAR(25),
	email VARCHAR(40),
	password VARCHAR(50),
	status VARCHAR(15),
	-- make sure phone or email is provided
	CHECK(COALESCE(phone, email) IS NOT NULL)
);

CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	url VARCHAR(200) NOT NULL,
	caption VARCHAR(240),
	lat REAL CHECK(lat IS NULL OR (lat >= -90 AND lat <= 90)),
	lng REAL, CHECK(lng IS NULL OR (lng >= -180 AND lng <= 180)),
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	contents VARCHAR(240) NOT NULL,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE
);

CREATE TABLE likes (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	-- polymorphic association
	post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
	comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE,
	-- make sure either post_id or comment_id is populated
	CHECK(
		COALESCE((post_id)::BOOLEAN::INTEGER, 0)
		+
		COALESCE((comment_id)::BOOLEAN::INTEGER, 0)
		= 1
	),
	-- make sure there is only one like per post or comment
	UNIQUE(user_id, post_id, comment_id)
);

CREATE TABLE photo_tags(
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
	x INTEGER NOT NULL,
	y INTEGER NOT NULL,
	-- make sure a user is mentioned only once per post and not multiple times
	UNIQUE(user_id, post_id)
);

CREATE TABLE caption_tags(
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
	-- make sure a user is mentioned link only once per comment and not multiple times
	UNIQUE(user_id, post_id)
);

CREATE TABLE hashtags (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	title VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE hashtags_posts (
	id SERIAL PRIMARY KEY,
	hashtag_id INTEGER NOT NULL REFERENCES hashtags(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
	UNIQUE (hashtag_id, post_id)
);

CREATE TABLE followers (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	leader_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	follower_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	-- One user can only follow one user once
	UNIQUE (leader_id, follower_id)
);
