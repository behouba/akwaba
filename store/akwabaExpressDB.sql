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
-- Name: delivery_address; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.delivery_address (
    id bigint NOT NULL,
    full_name character varying,
    phone_number character varying NOT NULL,
    location_description text,
    map_position point,
    area_id integer NOT NULL
);


ALTER TABLE public.delivery_address OWNER TO optimus92;

--
-- Name: TABLE delivery_address; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.delivery_address IS 'delivery address table';


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

ALTER SEQUENCE public.address_id_seq OWNED BY public.delivery_address.id;


--
-- Name: area; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.area (
    id integer NOT NULL,
    name character varying NOT NULL,
    short_name character varying NOT NULL,
    district_id integer
);


ALTER TABLE public.area OWNER TO optimus92;

--
-- Name: TABLE area; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.area IS 'all available town for delivery';


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
-- Name: customer_follow_parcel; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.customer_follow_parcel (
    customer_id integer NOT NULL,
    parcel_id integer NOT NULL
);


ALTER TABLE public.customer_follow_parcel OWNER TO optimus92;

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
-- Name: event; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.event (
    id smallint NOT NULL,
    name character varying NOT NULL,
    preview_step_id smallint,
    next_step_id smallint
);


ALTER TABLE public.event OWNER TO optimus92;

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
    cost money,
    created_at timestamp without time zone,
    address_id integer NOT NULL,
    office_id integer NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public."order" OWNER TO optimus92;

--
-- Name: TABLE "order"; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public."order" IS 'This table hold all order made by users.';


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
-- Name: parcel; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.parcel (
    id bigint NOT NULL,
    order_id integer NOT NULL,
    weight numeric NOT NULL,
    description text,
    office_id integer,
    address_id integer NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.parcel OWNER TO optimus92;

--
-- Name: parcel_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.parcel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parcel_id_seq OWNER TO optimus92;

--
-- Name: parcel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.parcel_id_seq OWNED BY public.parcel.id;


--
-- Name: parcel_state; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.parcel_state (
    id smallint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.parcel_state OWNER TO optimus92;

--
-- Name: payment_type; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.payment_type (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.payment_type OWNER TO optimus92;

--
-- Name: pickup_address; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.pickup_address (
    id bigint NOT NULL,
    description text,
    area_id integer NOT NULL
);


ALTER TABLE public.pickup_address OWNER TO optimus92;

--
-- Name: pickup_address_id_seq; Type: SEQUENCE; Schema: public; Owner: optimus92
--

CREATE SEQUENCE public.pickup_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pickup_address_id_seq OWNER TO optimus92;

--
-- Name: pickup_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: optimus92
--

ALTER SEQUENCE public.pickup_address_id_seq OWNED BY public.pickup_address.id;


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
-- Name: tracking; Type: TABLE; Schema: public; Owner: optimus92
--

CREATE TABLE public.tracking (
    order_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tracking OWNER TO optimus92;

--
-- Name: TABLE tracking; Type: COMMENT; Schema: public; Owner: optimus92
--

COMMENT ON TABLE public.tracking IS 'record of the history of orders';


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
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- Name: delivery_address id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery_address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


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
-- Name: parcel id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.parcel ALTER COLUMN id SET DEFAULT nextval('public.parcel_id_seq'::regclass);


--
-- Name: pickup_address id; Type: DEFAULT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.pickup_address ALTER COLUMN id SET DEFAULT nextval('public.pickup_address_id_seq'::regclass);


--
-- Data for Name: area; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.area (id, name, short_name, district_id) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.customer (id, first_name, last_name, registration_date, phone, email, is_email_verified, town_id, map_position) FROM stdin;
\.


--
-- Data for Name: customer_follow_parcel; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.customer_follow_parcel (customer_id, parcel_id) FROM stdin;
\.


--
-- Data for Name: customer_session; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.customer_session (customer_id, datetime, access_token) FROM stdin;
\.


--
-- Data for Name: delivery_address; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.delivery_address (id, full_name, phone_number, location_description, map_position, area_id) FROM stdin;
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
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.event (id, name, preview_step_id, next_step_id) FROM stdin;
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

COPY public."order" (id, customer_id, payment_type_id, cost, created_at, address_id, office_id, state_id) FROM stdin;
\.


--
-- Data for Name: order_state; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.order_state (id, name) FROM stdin;
\.


--
-- Data for Name: parcel; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.parcel (id, order_id, weight, description, office_id, address_id, state_id) FROM stdin;
\.


--
-- Data for Name: parcel_state; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.parcel_state (id, name) FROM stdin;
\.


--
-- Data for Name: payment_type; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.payment_type (id, name) FROM stdin;
\.


--
-- Data for Name: pickup_address; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.pickup_address (id, description, area_id) FROM stdin;
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public."position" (id, name) FROM stdin;
\.


--
-- Data for Name: tracking; Type: TABLE DATA; Schema: public; Owner: optimus92
--

COPY public.tracking (order_id, created_at) FROM stdin;
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
-- Name: parcel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.parcel_id_seq', 1, false);


--
-- Name: pickup_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: optimus92
--

SELECT pg_catalog.setval('public.pickup_address_id_seq', 1, false);


--
-- Name: delivery_address address_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery_address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: customer client_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


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
-- Name: parcel_state parcel_state_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.parcel_state
    ADD CONSTRAINT parcel_state_pkey PRIMARY KEY (id);


--
-- Name: payment_type payment_type_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.payment_type
    ADD CONSTRAINT payment_type_pkey PRIMARY KEY (id);


--
-- Name: pickup_address pickup_address_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.pickup_address
    ADD CONSTRAINT pickup_address_pkey PRIMARY KEY (id);


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
-- Name: area town_pkey; Type: CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.area
    ADD CONSTRAINT town_pkey PRIMARY KEY (id);


--
-- Name: delivery_address address_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.delivery_address
    ADD CONSTRAINT address_town_id_fkey FOREIGN KEY (area_id) REFERENCES public.area(id);


--
-- Name: customer_session client_session_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer_session
    ADD CONSTRAINT client_session_client_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: customer_follow_parcel customer_follow_parcel_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer_follow_parcel
    ADD CONSTRAINT customer_follow_parcel_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: customer customer_town_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.area(id);


--
-- Name: distance distance_town_a_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.distance
    ADD CONSTRAINT distance_town_a_fkey FOREIGN KEY (town_a) REFERENCES public.area(id);


--
-- Name: distance distance_town_b_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.distance
    ADD CONSTRAINT distance_town_b_fkey FOREIGN KEY (town_b) REFERENCES public.area(id);


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
    ADD CONSTRAINT office_town_id_fkey FOREIGN KEY (town_id) REFERENCES public.area(id);


--
-- Name: order order_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.pickup_address(id);


--
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: tracking order_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.tracking
    ADD CONSTRAINT order_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: order order_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.office(id);


--
-- Name: order order_payment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_payment_type_id_fkey FOREIGN KEY (payment_type_id) REFERENCES public.payment_type(id);


--
-- Name: order order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.order_state(id);


--
-- Name: parcel parcel_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.parcel
    ADD CONSTRAINT parcel_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.delivery_address(id);


--
-- Name: parcel parcel_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.parcel
    ADD CONSTRAINT parcel_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.office(id);


--
-- Name: parcel parcel_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.parcel
    ADD CONSTRAINT parcel_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- Name: parcel parcel_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.parcel
    ADD CONSTRAINT parcel_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.parcel_state(id);


--
-- Name: pickup_address pickup_address_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: optimus92
--

ALTER TABLE ONLY public.pickup_address
    ADD CONSTRAINT pickup_address_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.area(id);


--
-- PostgreSQL database dump complete
--

