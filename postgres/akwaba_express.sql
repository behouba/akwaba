--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

-- Started on 2019-08-06 17:06:15 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 50033)
-- Name: account_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_types (
    account_type_id smallint NOT NULL,
    name character varying NOT NULL,
    description text
);


--
-- TOC entry 197 (class 1259 OID 50039)
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    contact_name character varying NOT NULL,
    phone character varying NOT NULL,
    google_place character varying NOT NULL,
    description character varying NOT NULL,
    user_id integer NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 50045)
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areas (
    area_id integer NOT NULL,
    name character varying NOT NULL,
    city_id integer NOT NULL
);


--
-- TOC entry 199 (class 1259 OID 50051)
-- Name: areas_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.areas_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 199
-- Name: areas_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.areas_area_id_seq OWNED BY public.areas.area_id;


--
-- TOC entry 200 (class 1259 OID 50053)
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignments (
    assignment_id bigint NOT NULL,
    office_id integer NOT NULL,
    shipment_id integer NOT NULL,
    time_assigned timestamp without time zone DEFAULT now() NOT NULL,
    time_completed timestamp without time zone
);


--
-- TOC entry 201 (class 1259 OID 50057)
-- Name: assignments_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignments_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 201
-- Name: assignments_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignments_assignment_id_seq OWNED BY public.assignments.assignment_id;


--
-- TOC entry 202 (class 1259 OID 50059)
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    city_id integer NOT NULL,
    name character varying NOT NULL,
    country_id integer NOT NULL,
    office_id integer
);


--
-- TOC entry 203 (class 1259 OID 50065)
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 203
-- Name: cities_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;


--
-- TOC entry 204 (class 1259 OID 50067)
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    country_id smallint NOT NULL,
    name character varying NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 50408)
-- Name: user_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_updates (
    user_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    time_updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 50073)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    email character varying DEFAULT false NOT NULL,
    password character varying NOT NULL,
    account_type_id smallint DEFAULT 1 NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    is_phone_verified boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    recovery_token character varying
);


--
-- TOC entry 206 (class 1259 OID 50085)
-- Name: users_access_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_access_history (
    user_id integer NOT NULL,
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying,
    is_from_mobile boolean
);


--
-- TOC entry 207 (class 1259 OID 50091)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 207
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 208 (class 1259 OID 50093)
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    login character varying,
    password character varying,
    active_from timestamp without time zone DEFAULT now() NOT NULL,
    active_to timestamp without time zone,
    is_active boolean DEFAULT true NOT NULL,
    position_id smallint NOT NULL,
    office_id integer NOT NULL
);


--
-- TOC entry 209 (class 1259 OID 50101)
-- Name: employees_access_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees_access_history (
    employee_id integer NOT NULL,
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying,
    is_from_mobile boolean
);


--
-- TOC entry 210 (class 1259 OID 50108)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 210
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 211 (class 1259 OID 50110)
-- Name: order_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_states (
    order_state_id smallint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    description character varying
);


--
-- TOC entry 212 (class 1259 OID 50116)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    order_id bigint NOT NULL,
    user_id integer DEFAULT 14 NOT NULL,
    time_created timestamp without time zone DEFAULT now() NOT NULL,
    time_closed timestamp without time zone,
    sender_name character varying NOT NULL,
    sender_phone character varying NOT NULL,
    sender_area_id integer NOT NULL,
    sender_address character varying NOT NULL,
    recipient_name character varying NOT NULL,
    recipient_phone character varying NOT NULL,
    recipient_area_id integer NOT NULL,
    recipient_address character varying NOT NULL,
    shipment_category_id smallint NOT NULL,
    nature character varying NOT NULL,
    payment_option_id smallint NOT NULL,
    cost integer NOT NULL,
    distance numeric NOT NULL,
    order_state_id smallint NOT NULL
);


--
-- TOC entry 213 (class 1259 OID 50124)
-- Name: payment_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_options (
    payment_option_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- TOC entry 214 (class 1259 OID 50130)
-- Name: shipment_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_categories (
    shipment_category_id smallint NOT NULL,
    name character varying NOT NULL,
    min_cost integer,
    max_cost integer
);


--
-- TOC entry 215 (class 1259 OID 50136)
-- Name: shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipments (
    shipment_id bigint NOT NULL,
    order_id bigint NOT NULL,
    user_id integer NOT NULL,
    sender_name character varying NOT NULL,
    sender_phone character varying NOT NULL,
    sender_area_id integer NOT NULL,
    sender_address character varying NOT NULL,
    recipient_name character varying NOT NULL,
    recipient_phone character varying NOT NULL,
    recipient_area_id integer NOT NULL,
    recipient_address character varying NOT NULL,
    time_created timestamp without time zone DEFAULT now() NOT NULL,
    time_delivered timestamp without time zone,
    shipment_category_id integer NOT NULL,
    cost integer NOT NULL,
    nature character varying NOT NULL,
    weight numeric DEFAULT 0 NOT NULL,
    payment_option_id integer NOT NULL,
    distance numeric NOT NULL,
    shipment_state_id smallint NOT NULL,
    current_office_id integer
);


--
-- TOC entry 216 (class 1259 OID 50144)
-- Name: full_orders; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.full_orders AS
 SELECT o.order_id,
    s.shipment_id,
    o.user_id,
    o.time_created,
    o.time_closed,
    o.sender_name,
    o.sender_phone,
    o.sender_area_id,
    a1.name AS sender_area,
    o.sender_address,
    o.recipient_name,
    o.recipient_phone,
    o.recipient_area_id,
    a2.name AS recipient_area,
    o.recipient_address,
    o.shipment_category_id,
    sc.name AS shipment_category,
    o.nature,
    o.payment_option_id,
    po.name AS payment_option,
    o.cost,
    o.distance,
    ost.order_state_id,
    ost.name AS order_state
   FROM ((((((public.orders o
     LEFT JOIN public.order_states ost ON ((o.order_state_id = ost.order_state_id)))
     LEFT JOIN public.shipment_categories sc ON ((sc.shipment_category_id = o.shipment_category_id)))
     LEFT JOIN public.payment_options po ON ((po.payment_option_id = o.payment_option_id)))
     LEFT JOIN public.areas a1 ON ((a1.area_id = o.sender_area_id)))
     LEFT JOIN public.areas a2 ON ((a2.area_id = o.recipient_area_id)))
     LEFT JOIN public.shipments s ON ((s.order_id = o.order_id)));


--
-- TOC entry 217 (class 1259 OID 50149)
-- Name: shipment_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_states (
    shipment_state_id smallint NOT NULL,
    name character varying NOT NULL,
    code character varying,
    description character varying
);


--
-- TOC entry 218 (class 1259 OID 50155)
-- Name: full_shipments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.full_shipments AS
 SELECT s.shipment_id,
    s.order_id,
    s.user_id,
    s.sender_name,
    s.sender_phone,
    s.sender_area_id,
    sender_area.name AS sender_area,
    s.sender_address,
    s.recipient_name,
    s.recipient_phone,
    s.recipient_area_id,
    recipient_area.name AS recipient_area,
    s.recipient_address,
    s.time_created,
    s.time_delivered,
    s.shipment_category_id,
    sc.name AS shipment_category,
    s.cost,
    s.shipment_state_id,
    st.name AS shipment_state,
    s.weight,
    s.payment_option_id,
    po.name AS payment_option,
    s.distance,
    s.nature,
    s.current_office_id,
    c1.office_id AS pickup_office_id,
    c2.office_id AS delivery_office_id
   FROM (((((((public.shipments s
     LEFT JOIN public.areas sender_area ON ((sender_area.area_id = s.sender_area_id)))
     LEFT JOIN public.areas recipient_area ON ((recipient_area.area_id = s.recipient_area_id)))
     LEFT JOIN public.shipment_categories sc ON ((sc.shipment_category_id = s.shipment_category_id)))
     LEFT JOIN public.shipment_states st ON ((st.shipment_state_id = s.shipment_state_id)))
     LEFT JOIN public.payment_options po ON ((po.payment_option_id = s.payment_option_id)))
     LEFT JOIN public.cities c1 ON ((c1.city_id = sender_area.city_id)))
     LEFT JOIN public.cities c2 ON ((c2.city_id = recipient_area.city_id)));


--
-- TOC entry 228 (class 1259 OID 50421)
-- Name: mailing_data_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.mailing_data_view WITH (security_barrier='false') AS
 SELECT o.order_id,
    s.shipment_id,
    c.email,
    c.first_name
   FROM ((public.orders o
     LEFT JOIN public.users c ON ((o.user_id = c.user_id)))
     LEFT JOIN public.shipments s ON ((s.user_id = c.user_id)));


--
-- TOC entry 219 (class 1259 OID 50160)
-- Name: offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offices (
    office_id integer NOT NULL,
    name character varying NOT NULL,
    address character varying,
    city_id integer NOT NULL,
    manager_id integer,
    area_id integer NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 50166)
-- Name: offices_office_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offices_office_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 220
-- Name: offices_office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offices_office_id_seq OWNED BY public.offices.office_id;


--
-- TOC entry 221 (class 1259 OID 50168)
-- Name: orders_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders_history (
    order_id bigint NOT NULL,
    order_state_id smallint NOT NULL,
    time_created character varying DEFAULT now() NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 50175)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 222
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 223 (class 1259 OID 50177)
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.positions (
    position_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- TOC entry 224 (class 1259 OID 50183)
-- Name: shipments_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipments_history (
    shipment_id bigint NOT NULL,
    shipment_state_id smallint NOT NULL,
    time_inserted timestamp without time zone DEFAULT now() NOT NULL,
    area_id integer NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 50187)
-- Name: shipments_shipment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shipments_shipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 225
-- Name: shipments_shipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shipments_shipment_id_seq OWNED BY public.shipments.shipment_id;


--
-- TOC entry 226 (class 1259 OID 50189)
-- Name: shipments_tracking; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.shipments_tracking AS
 SELECT h.shipment_id,
    st.name AS shipment_state,
    h.time_inserted,
    c.name AS city,
    a.name AS area
   FROM (((public.shipments_history h
     LEFT JOIN public.shipment_states st ON ((st.shipment_state_id = h.shipment_state_id)))
     LEFT JOIN public.areas a ON ((a.area_id = h.area_id)))
     LEFT JOIN public.cities c ON ((c.city_id = a.city_id)));


--
-- TOC entry 3131 (class 2604 OID 50193)
-- Name: areas area_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas ALTER COLUMN area_id SET DEFAULT nextval('public.areas_area_id_seq'::regclass);


--
-- TOC entry 3133 (class 2604 OID 50194)
-- Name: assignments assignment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments ALTER COLUMN assignment_id SET DEFAULT nextval('public.assignments_assignment_id_seq'::regclass);


--
-- TOC entry 3134 (class 2604 OID 50195)
-- Name: cities city_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);


--
-- TOC entry 3140 (class 2604 OID 50196)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3144 (class 2604 OID 50197)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 3152 (class 2604 OID 50198)
-- Name: offices office_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices ALTER COLUMN office_id SET DEFAULT nextval('public.offices_office_id_seq'::regclass);


--
-- TOC entry 3148 (class 2604 OID 50199)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 3151 (class 2604 OID 50200)
-- Name: shipments shipment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments ALTER COLUMN shipment_id SET DEFAULT nextval('public.shipments_shipment_id_seq'::regclass);


--
-- TOC entry 3360 (class 0 OID 50033)
-- Dependencies: 196
-- Data for Name: account_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.account_types (account_type_id, name, description) FROM stdin;
1	Régulier	\N
2	Professionnel	\N
\.


--
-- TOC entry 3361 (class 0 OID 50039)
-- Dependencies: 197
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.addresses (contact_name, phone, google_place, description, user_id) FROM stdin;
\.


--
-- TOC entry 3362 (class 0 OID 50045)
-- Dependencies: 198
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.areas (area_id, name, city_id) FROM stdin;
1	Abobo, Gare	1
2	Abobo, Anador	1
3	Abobo, Samaké	1
4	Abobo, Akeikoi	1
5	Abobo, Dokui	1
6	Abobo, Zoo	1
7	Abobo, Baoulé	1
8	Abobo Sogefia	1
9	Abobo, Plaque	1
10	Abobo, Anonkoua	1
11	Abobo, Cité SOTRAPIM	1
12	Abobo, Agbekoi	1
13	Abobo, Té	1
14	Abobo, Cité Concorde SICOGI	1
15	Abobo, PK 18 Agoueto	1
16	Abobo, Sagbé Nord	1
17	Abobo, Belleville	1
18	Abobo, N’dotré	1
19	Adjamé, Saint-Michel	2
20	Adjamé, Williamsville	2
21	Adjamé,  Liberté	2
22	Adjamé, Dallas	2
23	Adjamé, Mosquée	2
24	Adjamé, Macaci	2
25	Adjamé, Sodeci	2
26	Adjamé, Paillet	2
27	Adjamé, Habitat Extension	2
28	Adjamé, Bracodi	2
29	Adjamé, Gendarmerie d’Agban	2
30	Adjamé, Terminus 14	2
31	Adjamé, Mirador	2
32	Attécoubé, Locodjro	3
33	Attécoubé, Quartier la paix	3
34	Attécoubé, Cité Fairmont	3
35	Attécoubé, Agban Village	3
36	Sebroko	3
37	Cocody, Danga	4
38	Cocody, Val Doyen 1	4
39	Cocody, Ambassades	4
40	Cocody, Mermoz	4
41	Cocody, Riviéra 1	4
42	Cocody, Riviéra 2	4
43	Cocody, Riviéra 3	4
44	Cocody, Riviéra 4	4
45	Cocody, Riviéra 5	4
46	Cocody, Anono	4
47	Cocody, M’pouto	4
48	Cocody, M’badon	4
49	Cocody, Akouédo	4
50	Cocody, Moscou	4
51	Cocody, Cité ATCI	4
52	Cocody, Bonoumin	4
53	Cocody, Université FHB	4
54	Cocody, Blockhauss	4
55	Cocody, Danga Nord	4
56	Cocody, Attoban	4
57	Cocody, Abbri 2000	4
58	Cocody, Gobelet	4
59	Cocody, Aghien	4
60	Cocody, Djibi	4
61	Cocody, Angré	4
62	Cocody, Cité SIR	4
63	Cocody, Rosier	4
64	Cocody, Riviéra Palmeraie	4
65	Cocody, 2 plateaux	4
66	Plateau	5
67	Yopougon, Selmer	6
68	Yopougon, Siporex	6
69	Yopougon, Bimbresso	6
70	Yopougon, Abadjin-kouté	6
71	Yopougon, Adiopodoumé	6
72	Yopougon, Annanéraie	6
73	Yopougon, Attié	6
74	Yopougon, Kouté	6
75	Yopougon, Banco nord	6
76	Yopougon, Gesco	6
77	Yopougon, Batim	6
78	Yopougon, Port-Bouet 2	6
79	Yopougon, Niangon-Lokoa	6
80	Yopougon, Niangon sud	6
81	Yopougon, Niangon nord	6
82	Yopougon, Abobo Doumé	6
83	Yopougon, Koweit	6
84	Yopougon, Zone industrielle	6
85	Yopougon, Sable	6
86	Yopougon, Sideci	6
87	Treichville Centre	7
88	Treichville, Zone industrielle	7
89	Treichville, Appolo	7
90	Treichville, Arras 3	7
91	Treichville, Biafra	7
92	Treichville, Cité du personnel	7
93	Treichville, CHU	7
94	Koumassi, Sicogi nord-est	8
95	Koumassi, Remblais	8
96	Koumassi, Port-Bouet II	8
97	Koumassi, Sicogi	8
98	Koumassi, Le Michigan	8
99	Marcory, Anoumabo	9
100	Marcory, Centre	9
101	Marcory, Zone 4C	9
102	Marcory, Biétry	9
103	Marcory, Potopoto	9
104	Port-bouet, Cité universitaire Vridi	10
105	Port-bouet, Abattoir	10
106	Port-bouet, Sogefia / Siporex	10
107	Port-bouet, Gonzagueville	10
108	Port-bouet, Mafiblé 1	10
109	Port-bouet, Mafible 2	10
110	Port-bouet, Ancien camp	10
111	Port-bouet, Nouveau camp	10
112	Port-bouet, Abouabou	10
113	Port-bouet, Aéroport	10
114	Bingerville	11
115	Anyama	12
\.


--
-- TOC entry 3364 (class 0 OID 50053)
-- Dependencies: 200
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assignments (assignment_id, office_id, shipment_id, time_assigned, time_completed) FROM stdin;
\.


--
-- TOC entry 3366 (class 0 OID 50059)
-- Dependencies: 202
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cities (city_id, name, country_id, office_id) FROM stdin;
2	Adjamé	1	1
1	Abobo	1	2
4	Cocody	1	4
5	Le Plateau	1	3
6	Yopougon	1	7
7	Treichville	1	5
8	Koumassi	1	5
9	Marcory	1	5
10	Port-Bouët	1	6
11	Bingerville	1	4
3	Attécoubé	1	3
12	Anyama	1	2
\.


--
-- TOC entry 3368 (class 0 OID 50067)
-- Dependencies: 204
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.countries (country_id, name) FROM stdin;
1	Côte d'Ivoire
\.


--
-- TOC entry 3388 (class 0 OID 50408)
-- Dependencies: 227
-- Data for Name: user_updates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_updates (user_id, first_name, last_name, phone, time_updated) FROM stdin;
\.


--
-- TOC entry 3369 (class 0 OID 50073)
-- Dependencies: 205
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, first_name, last_name, phone, email, password, account_type_id, is_email_verified, is_phone_verified, is_active, recovery_token) FROM stdin;
\.


--
-- TOC entry 3370 (class 0 OID 50085)
-- Dependencies: 206
-- Data for Name: users_access_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_access_history (user_id, access_time, ip_address, is_from_mobile) FROM stdin;
\.


--
-- TOC entry 3372 (class 0 OID 50093)
-- Dependencies: 208
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employees (employee_id, first_name, last_name, login, password, active_from, active_to, is_active, position_id, office_id) FROM stdin;
5	Kouame	Jean didier	didi	$2y$12$MjabRTOZJSlliFh87a0oSuCaOCZGVmhXkLm5Gtbin9m3V7L4bicI.	2019-07-22 11:00:17.96013	\N	t	2	4
6	Kouame	behouba	behouba	$2y$12$E3xn3cKtYsglKKT6BjBEkexJXKV6KWMdIITkyHiA8IgMmyVM8WTom	2019-07-22 11:12:40.435706	\N	t	1	1
7	Soro	Aicha	pety	$2y$12$0zNVACdC2OPI3JpD7ll.9uur5381JxjIsPgoyplCOUVXsO/rnnY5G	2019-07-22 11:17:35.214625	\N	t	2	7
8	Soro	Aicha	pety	$2y$12$0zNVACdC2OPI3JpD7ll.9uur5381JxjIsPgoyplCOUVXsO/rnnY5G	2019-07-22 19:41:42.850868	\N	t	1	1
\.


--
-- TOC entry 3373 (class 0 OID 50101)
-- Dependencies: 209
-- Data for Name: employees_access_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employees_access_history (employee_id, access_time, ip_address, is_from_mobile) FROM stdin;
\.


--
-- TOC entry 3381 (class 0 OID 50160)
-- Dependencies: 219
-- Data for Name: offices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offices (office_id, name, address, city_id, manager_id, area_id) FROM stdin;
1	Agence d’Adjamé Williamsville	Williamsville, Adjamé, Abidjan, Côte d'Ivoire	2	\N	20
2	Agence d’Abobo	Lycée Moderne D'abobo 1 & 2, Abidjan, Côte d'Ivoire	1	\N	1
3	Agence d’Adjamé Saint Michel	Eglise Catholique Saint Michel d'Adjamé, Adjamé, Abidjan, Côte d'Ivoire	2	\N	19
4	Agence de Cocody Faya	Cocody Faya	4	\N	64
5	Agence de Koumassi	Remblais, Koumassi, Abidjan, Côte d'Ivoire	8	\N	95
6	Agence de Port-Bouët	Port-Bouët	10	\N	107
7	Agence de Yopougon	Yopougon	6	\N	67
\.


--
-- TOC entry 3375 (class 0 OID 50110)
-- Dependencies: 211
-- Data for Name: order_states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_states (order_state_id, name, code, description) FROM stdin;
1	En attente de confirmation	PENDING_ORDER	\N
2	En cours de traitement	PROCESSING	\N
3	Terminée	COMPLETED	\N
4	Annulée	CANCELED	\N
\.


--
-- TOC entry 3376 (class 0 OID 50116)
-- Dependencies: 212
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders (order_id, user_id, time_created, time_closed, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, shipment_category_id, nature, payment_option_id, cost, distance, order_state_id) FROM stdin;
\.


--
-- TOC entry 3383 (class 0 OID 50168)
-- Dependencies: 221
-- Data for Name: orders_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders_history (order_id, order_state_id, time_created) FROM stdin;
\.


--
-- TOC entry 3377 (class 0 OID 50124)
-- Dependencies: 213
-- Data for Name: payment_options; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_options (payment_option_id, name, description) FROM stdin;
1	Paiement au ramassage	Le client paye les frais de livraison au moment de la collecte du colis par le coursier
2	Paiement à la livraison	Le destinataire de colis paye les frais de livraison à la livraison du colis
\.


--
-- TOC entry 3385 (class 0 OID 50177)
-- Dependencies: 223
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.positions (position_id, name, description) FROM stdin;
1	Manager de commandes en ligne	Personne chargée de la gestion de nouvelle commande en ligne, de leur assignation aux agences chargées de la collecte et de la livraison
2	Responsable d'agence	Personne chargée de la gestion de la collecte et de la livraison des colis dans les communes sous la responsabilité de son agence
3	Coursier	Personne chargée de la collecte et de la livraison des colis directement après des clients
\.


--
-- TOC entry 3378 (class 0 OID 50130)
-- Dependencies: 214
-- Data for Name: shipment_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipment_categories (shipment_category_id, name, min_cost, max_cost) FROM stdin;
1	Documents	1000	2000
2	Colis	1000	2300
\.


--
-- TOC entry 3380 (class 0 OID 50149)
-- Dependencies: 217
-- Data for Name: shipment_states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipment_states (shipment_state_id, name, code, description) FROM stdin;
1	En attente de ramassage	\N	\N
2	Ramassé	\N	\N
3	Échec de ramassage	\N	\N
4	Arrivé à l'agence locale de distribution	\N	\N
5	Depart de l'agence locale de distribution	\N	\N
6	Livré	\N	\N
7	Échec de livraison	\N	\N
8	Retourné	\N	\N
9	Échec d'acheminement	\N	\N
\.


--
-- TOC entry 3379 (class 0 OID 50136)
-- Dependencies: 215
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipments (shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, time_created, time_delivered, shipment_category_id, cost, nature, weight, payment_option_id, distance, shipment_state_id, current_office_id) FROM stdin;
\.


--
-- TOC entry 3386 (class 0 OID 50183)
-- Dependencies: 224
-- Data for Name: shipments_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipments_history (shipment_id, shipment_state_id, time_inserted, area_id) FROM stdin;
\.


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 199
-- Name: areas_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.areas_area_id_seq', 115, true);


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 201
-- Name: assignments_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.assignments_assignment_id_seq', 1, false);


--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 203
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 12, true);


--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 207
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 56, true);


--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 210
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 8, true);


--
-- TOC entry 3407 (class 0 OID 0)
-- Dependencies: 220
-- Name: offices_office_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.offices_office_id_seq', 7, true);


--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 222
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 1632345253, true);


--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 225
-- Name: shipments_shipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shipments_shipment_id_seq', 1923452358, true);


--
-- TOC entry 3157 (class 2606 OID 50202)
-- Name: account_types account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (account_type_id);


--
-- TOC entry 3159 (class 2606 OID 50204)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (contact_name, phone, google_place, description, user_id);


--
-- TOC entry 3161 (class 2606 OID 50206)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area_id);


--
-- TOC entry 3163 (class 2606 OID 50208)
-- Name: cities cities_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_name_key UNIQUE (name);


--
-- TOC entry 3165 (class 2606 OID 50210)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 3167 (class 2606 OID 50212)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- TOC entry 3169 (class 2606 OID 50214)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3171 (class 2606 OID 50216)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 3173 (class 2606 OID 50218)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3175 (class 2606 OID 50220)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3197 (class 2606 OID 50222)
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (office_id);


--
-- TOC entry 3199 (class 2606 OID 50224)
-- Name: orders_history order_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_pkey PRIMARY KEY (order_id, order_state_id);


--
-- TOC entry 3177 (class 2606 OID 50226)
-- Name: order_states order_states_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_code_key UNIQUE (code);


--
-- TOC entry 3179 (class 2606 OID 50228)
-- Name: order_states order_states_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_name_key UNIQUE (name);


--
-- TOC entry 3181 (class 2606 OID 50230)
-- Name: order_states order_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_pkey PRIMARY KEY (order_state_id);


--
-- TOC entry 3183 (class 2606 OID 50232)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 3185 (class 2606 OID 50234)
-- Name: payment_options payment_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_options
    ADD CONSTRAINT payment_options_pkey PRIMARY KEY (payment_option_id);


--
-- TOC entry 3201 (class 2606 OID 50236)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- TOC entry 3187 (class 2606 OID 50238)
-- Name: shipment_categories shipment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_categories
    ADD CONSTRAINT shipment_categories_pkey PRIMARY KEY (shipment_category_id);


--
-- TOC entry 3191 (class 2606 OID 50240)
-- Name: shipment_states shipment_states_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_code_key UNIQUE (code);


--
-- TOC entry 3193 (class 2606 OID 50242)
-- Name: shipment_states shipment_states_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_name_key UNIQUE (name);


--
-- TOC entry 3195 (class 2606 OID 50244)
-- Name: shipment_states shipment_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_pkey PRIMARY KEY (shipment_state_id);


--
-- TOC entry 3189 (class 2606 OID 50246)
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (shipment_id);


--
-- TOC entry 3202 (class 2606 OID 50247)
-- Name: addresses addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3203 (class 2606 OID 50252)
-- Name: areas areas_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id);


--
-- TOC entry 3204 (class 2606 OID 50257)
-- Name: assignments assignments_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3205 (class 2606 OID 50262)
-- Name: cities cities_contry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_contry_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3206 (class 2606 OID 50267)
-- Name: cities cities_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id);


--
-- TOC entry 3234 (class 2606 OID 50415)
-- Name: user_updates user_updates_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_updates
    ADD CONSTRAINT user_updates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3208 (class 2606 OID 50272)
-- Name: users_access_history users_access_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_access_history
    ADD CONSTRAINT users_access_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3207 (class 2606 OID 50277)
-- Name: users users_account_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_account_type_id_fkey FOREIGN KEY (account_type_id) REFERENCES public.account_types(account_type_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3211 (class 2606 OID 50282)
-- Name: employees_access_history employees_access_history_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees_access_history
    ADD CONSTRAINT employees_access_history_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3209 (class 2606 OID 50287)
-- Name: employees employees_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3210 (class 2606 OID 50292)
-- Name: employees employees_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3226 (class 2606 OID 50297)
-- Name: offices offices_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 3227 (class 2606 OID 50302)
-- Name: offices offices_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3228 (class 2606 OID 50307)
-- Name: offices offices_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3229 (class 2606 OID 50312)
-- Name: orders_history order_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 3230 (class 2606 OID 50317)
-- Name: orders_history order_history_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_states(order_state_id);


--
-- TOC entry 3212 (class 2606 OID 50322)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3213 (class 2606 OID 50327)
-- Name: orders orders_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_states(order_state_id);


--
-- TOC entry 3214 (class 2606 OID 50332)
-- Name: orders orders_payment_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_payment_option_id_fkey FOREIGN KEY (payment_option_id) REFERENCES public.payment_options(payment_option_id);


--
-- TOC entry 3215 (class 2606 OID 50337)
-- Name: orders orders_recipient_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_recipient_area_id_fkey FOREIGN KEY (recipient_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 3216 (class 2606 OID 50342)
-- Name: orders orders_sender_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_sender_area_id_fkey FOREIGN KEY (sender_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 3217 (class 2606 OID 50347)
-- Name: orders orders_shipment_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_shipment_category_id_fkey FOREIGN KEY (shipment_category_id) REFERENCES public.shipment_categories(shipment_category_id);


--
-- TOC entry 3218 (class 2606 OID 50352)
-- Name: shipments shipments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3231 (class 2606 OID 50357)
-- Name: shipments_history shipments_history_shipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT shipments_history_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments(shipment_id);


--
-- TOC entry 3219 (class 2606 OID 50362)
-- Name: shipments shipments_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_office_id_fkey FOREIGN KEY (current_office_id) REFERENCES public.offices(office_id);


--
-- TOC entry 3220 (class 2606 OID 50367)
-- Name: shipments shipments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 3221 (class 2606 OID 50372)
-- Name: shipments shipments_payment_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_payment_option_id_fkey FOREIGN KEY (payment_option_id) REFERENCES public.payment_options(payment_option_id);


--
-- TOC entry 3222 (class 2606 OID 50377)
-- Name: shipments shipments_recipient_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_recipient_area_id_fkey FOREIGN KEY (recipient_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 3223 (class 2606 OID 50382)
-- Name: shipments shipments_sender_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_sender_area_id_fkey FOREIGN KEY (sender_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 3224 (class 2606 OID 50387)
-- Name: shipments shipments_shipment_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_category_id_fkey FOREIGN KEY (shipment_category_id) REFERENCES public.shipment_categories(shipment_category_id);


--
-- TOC entry 3225 (class 2606 OID 50392)
-- Name: shipments shipments_shipment_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_state_id_fkey FOREIGN KEY (shipment_state_id) REFERENCES public.shipment_states(shipment_state_id);


--
-- TOC entry 3232 (class 2606 OID 50397)
-- Name: shipments_history trackings_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT trackings_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 3233 (class 2606 OID 50402)
-- Name: shipments_history trackings_shipment_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT trackings_shipment_state_id_fkey FOREIGN KEY (shipment_state_id) REFERENCES public.shipment_states(shipment_state_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2019-08-06 17:06:16 MSK

--
-- PostgreSQL database dump complete
--

