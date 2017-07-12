	CREATE TABLE IF NOT EXISTS occupations (
		id INTEGER PRIMARY KEY,
		name TEXT,
		group_id INTEGER
		);

	CREATE TABLE IF NOT EXISTS guests (
		id INTEGER PRIMARY KEY,
		name TEXT,
		occupation INTEGER
		);

	CREATE TABLE IF NOT EXISTS shows (
		id INTEGER PRIMARY KEY,
		showdate TEXT,
		year_id INTEGER
		);

	CREATE TABLE IF NOT EXISTS show_guests (
		id INTEGER PRIMARY KEY,
		show_id INTEGER,
		guest_id INTEGER
		);

		CREATE TABLE IF NOT EXISTS groups (
		id INTEGER PRIMARY KEY,
		name TEXT
		);

		CREATE TABLE IF NOT EXISTS years (
		id INTEGER PRIMARY KEY,
		year INTEGER
		);