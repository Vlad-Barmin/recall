-- Recall — схема базы данных
-- Выполнить в SQL-редакторе Supabase (или любом клиенте PostgreSQL)
-- перед импортом воркфлоу в n8n.
--
-- Порядок создания важен: questions ссылается на topics,
-- answers ссылается на questions.

-- Темы, по которым генерируются вопросы.
-- is_active позволяет отключить тему, не удаляя её и связанную историю.
create table public.topics (
  id bigint generated always as identity not null,
  name text not null,
  is_active boolean not null default true,
  constraint topics_pkey primary key (id),
  constraint topics_name_key unique (name)
);

-- Сгенерированные вопросы с эталонными ответами.
-- status: 'pending' — отправлен и ждёт ответа, 'answered' — обработан.
create table public.questions (
  id bigint generated always as identity not null,
  topic_id bigint not null,
  question_text text not null,
  reference_answer text not null,
  status text not null default 'pending'::text,
  created_at timestamp with time zone not null default now(),
  constraint questions_pkey primary key (id),
  constraint questions_topic_id_fkey foreign key (topic_id) references topics (id)
);

-- Результаты проверки ответов.
-- verdict: 'correct' | 'partial' | 'incorrect'.
-- missed и explanation допускают NULL: при верном ответе упускать нечего.
create table public.answers (
  id bigint generated always as identity not null,
  question_id bigint not null,
  user_answer text not null,
  verdict text not null,
  missed text null,
  explanation text null,
  created_at timestamp with time zone not null default now(),
  constraint answers_pkey primary key (id),
  constraint answers_question_id_fkey foreign key (question_id) references questions (id)
);

-- Наполнение набором тем. Заменить на свои.
insert into public.topics (name) values
  ('SQL: выборки и джойны'),
  ('SQL: индексы и производительность'),
  ('Row Level Security в Postgres'),
  ('Ключи доступа: anon и service role'),
  ('Миграции базы данных'),
  ('async/await и промисы'),
  ('Обработка ошибок в JS'),
  ('TypeScript: типы и интерфейсы'),
  ('REST: методы и коды ответов'),
  ('Вебхуки: приём и верификация'),
  ('Переменные окружения и секреты'),
  ('Docker: образы и контейнеры'),
  ('Git: ветки и слияния');
