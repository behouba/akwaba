--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: check_unique_town_pair(integer, integer); Type: FUNCTION; Schema: public; Owner: optimus92
--

CREATE FUNCTION public.check_unique_town_pair(town1id integer, town2id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE retval INTEGER DEFAULT 0;
BEGIN
SELECT COUNT(*) INTO retval FROM (
  SELECT * FROM distance WHERE town_a = town1id AND town_b = town2Id
  UNION ALL
  SELECT * FROM distance WHERE town_a = town2Id AND town_b = town1Id
) AS pairs;
RETURN retval;
END
$$;


ALTER FUNCTION public.check_unique_town_pair(town1id integer, town2id integer) OWNER TO optimus92;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.address (
    id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    phone_number character varying NOT NULL,
    location_description text,
    map_position point,
    town_id integer NOT NULL
);


ALTER TABLE public.address OWNER TO optimus92;

--
-- Name: TABLE address; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.address IS 'delivery address table';


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_id_seq OWNER TO optimus92;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.address_id_seq OWNED BY public.address.id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.category OWNER TO optimus92;

--
-- Name: TABLE category; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.category IS 'order product''s category';


--
-- Name: customer; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    registration_date timestamp without time zone DEFAULT now() NOT NULL,
    phone character varying NOT NULL,
    email character varying,
    is_email_verified boolean NOT NULL,
    town_id integer,
    map_position point
);


ALTER TABLE public.customer OWNER TO optimus92;

--
-- Name: TABLE customer; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.customer IS 'This table hold user''s information.';


--
-- Name: client_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_id_seq OWNER TO optimus92;

--
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.customer.id;


--
-- Name: collect; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.collect (
    id bigint NOT NULL,
    date date NOT NULL,
    employee_id integer NOT NULL,
    collect_hour_id integer NOT NULL,
    collect_state_id integer NOT NULL,
    note text
);


ALTER TABLE public.collect OWNER TO optimus92;

--
-- Name: collect_hour; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.collect_hour (
    id integer NOT NULL,
    description character varying NOT NULL,
    hour time without time zone NOT NULL
);


ALTER TABLE public.collect_hour OWNER TO optimus92;

--
-- Name: collect_state; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.collect_state (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.collect_state OWNER TO optimus92;

--
-- Name: collecting_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.collecting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collecting_id_seq OWNER TO optimus92;

--
-- Name: collecting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.collecting_id_seq OWNED BY public.collect.id;


--
-- Name: customer_follow_order; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.customer_follow_order (
    customer_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.customer_follow_order OWNER TO optimus92;

--
-- Name: customer_session; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.customer_session (
    customer_id integer NOT NULL,
    datetime timestamp without time zone NOT NULL,
    access_token character varying NOT NULL
);


ALTER TABLE public.customer_session OWNER TO optimus92;

--
-- Name: delivery; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.delivery (
    id bigint NOT NULL,
    date date NOT NULL,
    delivery_hour_id integer NOT NULL,
    delivery_state_id integer NOT NULL,
    employee_id integer NOT NULL,
    note text
);


ALTER TABLE public.delivery OWNER TO optimus92;

--
-- Name: delivery_hour; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.delivery_hour (
    id integer NOT NULL,
    hour time without time zone NOT NULL,
    description character varying
);


ALTER TABLE public.delivery_hour OWNER TO optimus92;

--
-- Name: delivery_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.delivery_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivery_id_seq OWNER TO optimus92;

--
-- Name: delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.delivery_id_seq OWNED BY public.delivery.id;


--
-- Name: delivery_state; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.delivery_state (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.delivery_state OWNER TO optimus92;

--
-- Name: distance; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.distance (
    town_a integer NOT NULL,
    town_b integer NOT NULL,
    coefficient real NOT NULL,
    CONSTRAINT unique_town_pair CHECK ((public.check_unique_town_pair(town_a, town_b) < 1))
);


ALTER TABLE public.distance OWNER TO optimus92;

--
-- Name: district; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.district (
    id smallint NOT NULL,
    name character varying NOT NULL,
    short_name character varying NOT NULL
);


ALTER TABLE public.district OWNER TO optimus92;

--
-- Name: district_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.district_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.district_id_seq OWNER TO optimus92;

--
-- Name: district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.district_id_seq OWNED BY public.district.id;


--
-- Name: employee; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.employee (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    position_id integer NOT NULL,
    office_id integer NOT NULL
);


ALTER TABLE public.employee OWNER TO optimus92;

--
-- Name: employee_auth_credential; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.employee_auth_credential (
    employee_id integer NOT NULL,
    user_name character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE public.employee_auth_credential OWNER TO optimus92;

--
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_id_seq OWNER TO optimus92;

--
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;


--
-- Name: employee_session; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.employee_session (
    employee_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    access_token character varying NOT NULL
);


ALTER TABLE public.employee_session OWNER TO optimus92;

--
-- Name: message; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.message (
    client_id integer NOT NULL,
    employee_id integer,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    message_origin_id integer NOT NULL
);


ALTER TABLE public.message OWNER TO optimus92;

--
-- Name: message_origin; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.message_origin (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.message_origin OWNER TO optimus92;

--
-- Name: office; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.office (
    id integer NOT NULL,
    name character varying NOT NULL,
    town_id integer NOT NULL
);


ALTER TABLE public.office OWNER TO optimus92;

--
-- Name: TABLE office; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.office IS 'delivery service physical offices ';


--
-- Name: order; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public."order" (
    id bigint NOT NULL,
    customer_id integer NOT NULL,
    payment_type_id integer NOT NULL,
    category_id integer NOT NULL,
    weight integer,
    cost money,
    created_at timestamp without time zone,
    description text,
    size_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public."order" OWNER TO optimus92;

--
-- Name: TABLE "order"; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public."order" IS 'This table hold all order made by users.';


--
-- Name: order_history; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.order_history (
    order_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    order_state_id integer NOT NULL
);


ALTER TABLE public.order_history OWNER TO optimus92;

--
-- Name: TABLE order_history; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.order_history IS 'record of the history of orders';


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_id_seq OWNER TO optimus92;

--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- Name: order_in_collecting; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.order_in_collecting (
    collecting_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.order_in_collecting OWNER TO optimus92;

--
-- Name: TABLE order_in_collecting; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.order_in_collecting IS 'many to many relation table between order and collecting';


--
-- Name: order_in_delivery; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.order_in_delivery (
    delivery_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.order_in_delivery OWNER TO optimus92;

--
-- Name: TABLE order_in_delivery; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.order_in_delivery IS 'many to many relationship table between order and delivery';


--
-- Name: order_state; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.order_state (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.order_state OWNER TO optimus92;

--
-- Name: TABLE order_state; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.order_state IS 'all possible order states.';


--
-- Name: payment_type; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.payment_type (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.payment_type OWNER TO optimus92;

--
-- Name: position; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public."position" (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public."position" OWNER TO optimus92;

--
-- Name: TABLE "position"; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public."position" IS 'all possible position for an employee';


--
-- Name: town; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.town (
    id integer NOT NULL,
    name character varying NOT NULL,
    short_name character varying NOT NULL,
    district_id integer
);


ALTER TABLE public.town OWNER TO optimus92;

--
-- Name: TABLE town; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.town IS 'all available town for delivery';


--
-- Name: weight; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.weight (
    id integer NOT NULL,
    "from" real NOT NULL,
    "to" real NOT NULL,
    base_price money
);


ALTER TABLE public.weight OWNER TO optimus92;

--
-- Name: TABLE weight; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.weight IS 'order sizes category';


--
-- Name: address id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


--
-- Name: collect id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect ALTER COLUMN id SET DEFAULT nextval('public.collecting_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- Name: delivery id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery ALTER COLUMN id SET DEFAULT nextval('public.delivery_id_seq'::regclass);


--
-- Name: district id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.district ALTER COLUMN id SET DEFAULT nextval('public.district_id_seq'::regclass);


--
-- Name: employee id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee ALTER COLUMN id SET DEFAULT nextval('public.employee_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.address (id, first_name, last_name, phone_number, location_description, map_position, town_id) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.category (id, name) FROM stdin;
\.


--
-- Data for Name: collect; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.collect (id, date, employee_id, collect_hour_id, collect_state_id, note) FROM stdin;
\.


--
-- Data for Name: collect_hour; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.collect_hour (id, description, hour) FROM stdin;
\.


--
-- Data for Name: collect_state; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.collect_state (id, name) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.customer (id, first_name, last_name, registration_date, phone, email, is_email_verified, town_id, map_position) FROM stdin;
\.


--
-- Data for Name: customer_follow_order; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.customer_follow_order (customer_id, order_id) FROM stdin;
\.


--
-- Data for Name: customer_session; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.customer_session (customer_id, datetime, access_token) FROM stdin;
\.


--
-- Data for Name: delivery; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.delivery (id, date, delivery_hour_id, delivery_state_id, employee_id, note) FROM stdin;
\.


--
-- Data for Name: delivery_hour; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.delivery_hour (id, hour, description) FROM stdin;
\.


--
-- Data for Name: delivery_state; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.delivery_state (id, name) FROM stdin;
\.


--
-- Data for Name: distance; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.distance (town_a, town_b, coefficient) FROM stdin;
\.


--
-- Data for Name: district; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.district (id, name, short_name) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.employee (id, first_name, last_name, position_id, office_id) FROM stdin;
\.


--
-- Data for Name: employee_auth_credential; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.employee_auth_credential (employee_id, user_name, password) FROM stdin;
\.


--
-- Data for Name: employee_session; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.employee_session (employee_id, created_at, access_token) FROM stdin;
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.message (client_id, employee_id, body, created_at, message_origin_id) FROM stdin;
\.


--
-- Data for Name: message_origin; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.message_origin (id, name) FROM stdin;
\.


--
-- Data for Name: office; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.office (id, name, town_id) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public."order" (id, customer_id, payment_type_id, category_id, weight, cost, created_at, description, size_id, address_id) FROM stdin;
\.


--
-- Data for Name: order_history; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.order_history (order_id, created_at, order_state_id) FROM stdin;
\.


--
-- Data for Name: order_in_collecting; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.order_in_collecting (collecting_id, order_id) FROM stdin;
\.


--
-- Data for Name: order_in_delivery; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.order_in_delivery (delivery_id, order_id) FROM stdin;
\.


--
-- Data for Name: order_state; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.order_state (id, name) FROM stdin;
\.


--
-- Data for Name: payment_type; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.payment_type (id, name) FROM stdin;
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public."position" (id, name) FROM stdin;
\.


--
-- Data for Name: town; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.town (id, name, short_name, district_id) FROM stdin;
\.


--
-- Data for Name: weight; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.weight (id, "from", "to", base_price) FROM stdin;
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.address_id_seq', 1, false);


--
-- Name: client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.client_id_seq', 1, false);


--
-- Name: collecting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.collecting_id_seq', 1, false);


--
-- Name: delivery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.delivery_id_seq', 1, false);


--
-- Name: district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.district_id_seq', 1, false);


--
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.employee_id_seq', 1, false);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.order_id_seq', 1, false);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: customer client_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- Name: collect_hour collecting_hour_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect_hour
    ADD CONSTRAINT collecting_hour_pkey PRIMARY KEY (id);


--
-- Name: collect collecting_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect
    ADD CONSTRAINT collecting_pkey PRIMARY KEY (id);


--
-- Name: collect_state collecting_state_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect_state
    ADD CONSTRAINT collecting_state_pkey PRIMARY KEY (id);


--
-- Name: customer_follow_order customer_follow_order_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer_follow_order
    ADD CONSTRAINT customer_follow_order_pkey PRIMARY KEY (customer_id, order_id);


--
-- Name: delivery_hour delivery_hour_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery_hour
    ADD CONSTRAINT delivery_hour_pkey PRIMARY KEY (id);


--
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (id);


--
-- Name: delivery_state delivery_state_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery_state
    ADD CONSTRAINT delivery_state_pkey PRIMARY KEY (id);


--
-- Name: distance distance_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.distance
    ADD CONSTRAINT distance_pkey PRIMARY KEY (town_a, town_b);


--
-- Name: district district_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.district
    ADD CONSTRAINT district_pkey PRIMARY KEY (id);


--
-- Name: employee_auth_credential employee_auth_credential_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee_auth_credential
    ADD CONSTRAINT employee_auth_credential_employee_id_key UNIQUE (employee_id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: message_origin message_origin_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.message_origin
    ADD CONSTRAINT message_origin_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (client_id);


--
-- Name: office office_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.office
    ADD CONSTRAINT office_pkey PRIMARY KEY (id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_state order_state_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_state
    ADD CONSTRAINT order_state_pkey PRIMARY KEY (id);


--
-- Name: payment_type payment_type_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.payment_type
    ADD CONSTRAINT payment_type_pkey PRIMARY KEY (id);


--
-- Name: position position_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id);


--
-- Name: weight size_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.weight
    ADD CONSTRAINT size_pkey PRIMARY KEY (id);


--
-- Name: town town_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.town
    ADD CONSTRAINT town_pkey PRIMARY KEY (id);


--
-- Name: address address_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.town(id);


--
-- Name: customer_session client_session_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer_session
    ADD CONSTRAINT client_session_client_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: collect collecting_collecting_hour_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect
    ADD CONSTRAINT collecting_collecting_hour_id_fkey FOREIGN KEY (collect_hour_id) REFERENCES public.collect_hour(id);


--
-- Name: collect collecting_collecting_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect
    ADD CONSTRAINT collecting_collecting_state_id_fkey FOREIGN KEY (collect_state_id) REFERENCES public.collect_state(id);


--
-- Name: collect collecting_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.collect
    ADD CONSTRAINT collecting_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- Name: customer_follow_order customer_follow_order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer_follow_order
    ADD CONSTRAINT customer_follow_order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: customer_follow_order customer_follow_order_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer_follow_order
    ADD CONSTRAINT customer_follow_order_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: customer customer_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.town(id);


--
-- Name: delivery delivery_delivery_hour_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_delivery_hour_id_fkey FOREIGN KEY (delivery_hour_id) REFERENCES public.delivery_hour(id);


--
-- Name: delivery delivery_delivery_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_delivery_state_id_fkey FOREIGN KEY (delivery_state_id) REFERENCES public.delivery_state(id);


--
-- Name: delivery delivery_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- Name: distance distance_town_a_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.distance
    ADD CONSTRAINT distance_town_a_fkey FOREIGN KEY (town_a) REFERENCES public.town(id);


--
-- Name: distance distance_town_b_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.distance
    ADD CONSTRAINT distance_town_b_fkey FOREIGN KEY (town_b) REFERENCES public.town(id);


--
-- Name: employee_auth_credential employee_auth_credential_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee_auth_credential
    ADD CONSTRAINT employee_auth_credential_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- Name: employee_session employee_login_session_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee_session
    ADD CONSTRAINT employee_login_session_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- Name: employee employee_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.employee(id);


--
-- Name: employee employee_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_position_id_fkey FOREIGN KEY (position_id) REFERENCES public."position"(id);


--
-- Name: message message_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.customer(id);


--
-- Name: message message_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(id);


--
-- Name: message message_message_origin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_message_origin_id_fkey FOREIGN KEY (message_origin_id) REFERENCES public.message_origin(id);


--
-- Name: office office_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.office
    ADD CONSTRAINT office_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.town(id);


--
-- Name: order order_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- Name: order order_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: order_history order_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_history
    ADD CONSTRAINT order_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order_history order_history_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_history
    ADD CONSTRAINT order_history_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_state(id);


--
-- Name: order_in_collecting order_in_collecting_collecting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_in_collecting
    ADD CONSTRAINT order_in_collecting_collecting_id_fkey FOREIGN KEY (collecting_id) REFERENCES public.collect(id);


--
-- Name: order_in_collecting order_in_collecting_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_in_collecting
    ADD CONSTRAINT order_in_collecting_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order_in_delivery order_in_delivery_delivery_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_in_delivery
    ADD CONSTRAINT order_in_delivery_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.delivery(id);


--
-- Name: order_in_delivery order_in_delivery_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.order_in_delivery
    ADD CONSTRAINT order_in_delivery_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order order_payment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_payment_type_id_fkey FOREIGN KEY (payment_type_id) REFERENCES public.payment_type(id);


--
-- Name: order order_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_size_id_fkey FOREIGN KEY (size_id) REFERENCES public.weight(id);


--
-- PostgreSQL database dump complete
--

