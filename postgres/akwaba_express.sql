--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 11.4

-- Started on 2019-09-10 19:36:08 MSK

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
-- TOC entry 196 (class 1259 OID 18118)
-- Name: account_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_types (
    account_type_id smallint NOT NULL,
    name character varying NOT NULL,
    description text
);


ALTER TABLE public.account_types OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 18124)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    contact_name character varying NOT NULL,
    phone character varying NOT NULL,
    google_place character varying NOT NULL,
    description character varying NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 18130)
-- Name: areas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.areas (
    area_id integer NOT NULL,
    name character varying NOT NULL,
    city_id integer NOT NULL
);


ALTER TABLE public.areas OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 18136)
-- Name: areas_area_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.areas_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.areas_area_id_seq OWNER TO postgres;

--
-- TOC entry 3145 (class 0 OID 0)
-- Dependencies: 199
-- Name: areas_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.areas_area_id_seq OWNED BY public.areas.area_id;


--
-- TOC entry 200 (class 1259 OID 18138)
-- Name: assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assignments (
    assignment_id bigint NOT NULL,
    office_id integer NOT NULL,
    shipment_id integer NOT NULL,
    time_assigned timestamp without time zone DEFAULT now() NOT NULL,
    time_completed timestamp without time zone
);


ALTER TABLE public.assignments OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 18142)
-- Name: assignments_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assignments_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assignments_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 3148 (class 0 OID 0)
-- Dependencies: 201
-- Name: assignments_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assignments_assignment_id_seq OWNED BY public.assignments.assignment_id;


--
-- TOC entry 202 (class 1259 OID 18144)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    city_id integer NOT NULL,
    name character varying NOT NULL,
    country_id integer NOT NULL,
    office_id integer
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 18150)
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_city_id_seq OWNER TO postgres;

--
-- TOC entry 3151 (class 0 OID 0)
-- Dependencies: 203
-- Name: cities_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;


--
-- TOC entry 204 (class 1259 OID 18152)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    country_id smallint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 18185)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 18193)
-- Name: employees_access_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees_access_history (
    employee_id integer NOT NULL,
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying,
    is_from_mobile boolean
);


ALTER TABLE public.employees_access_history OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 18200)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_employee_id_seq OWNER TO postgres;

--
-- TOC entry 3156 (class 0 OID 0)
-- Dependencies: 211
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 212 (class 1259 OID 18202)
-- Name: order_states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_states (
    order_state_id smallint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    description character varying
);


ALTER TABLE public.order_states OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 18208)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id bigint NOT NULL,
    user_id integer DEFAULT 1 NOT NULL,
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


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 18216)
-- Name: payment_options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_options (
    payment_option_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.payment_options OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 18222)
-- Name: shipment_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipment_categories (
    shipment_category_id smallint NOT NULL,
    name character varying NOT NULL,
    min_cost integer,
    max_cost integer
);


ALTER TABLE public.shipment_categories OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 18228)
-- Name: shipments; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.shipments OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 18236)
-- Name: full_orders; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE public.full_orders OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 18241)
-- Name: shipment_states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipment_states (
    shipment_state_id smallint NOT NULL,
    name character varying NOT NULL,
    code character varying,
    description character varying
);


ALTER TABLE public.shipment_states OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 18247)
-- Name: full_shipments; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE public.full_shipments OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 18165)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18252)
-- Name: mailing_data_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mailing_data_view WITH (security_barrier='false') AS
 SELECT o.order_id,
    s.shipment_id,
    c.email,
    c.first_name
   FROM ((public.orders o
     LEFT JOIN public.users c ON ((o.user_id = c.user_id)))
     LEFT JOIN public.shipments s ON ((s.user_id = c.user_id)));


ALTER TABLE public.mailing_data_view OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 18257)
-- Name: offices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offices (
    office_id integer NOT NULL,
    name character varying NOT NULL,
    address character varying,
    city_id integer NOT NULL,
    manager_id integer,
    area_id integer NOT NULL,
    longitude numeric,
    latitude numeric,
    phone1 character varying,
    phone2 character varying
);


ALTER TABLE public.offices OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18263)
-- Name: offices_office_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.offices_office_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.offices_office_id_seq OWNER TO postgres;

--
-- TOC entry 3169 (class 0 OID 0)
-- Dependencies: 222
-- Name: offices_office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.offices_office_id_seq OWNED BY public.offices.office_id;


--
-- TOC entry 223 (class 1259 OID 18265)
-- Name: orders_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_history (
    order_id bigint NOT NULL,
    order_state_id smallint NOT NULL,
    time_created character varying DEFAULT now() NOT NULL
);


ALTER TABLE public.orders_history OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 18272)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO postgres;

--
-- TOC entry 3172 (class 0 OID 0)
-- Dependencies: 224
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 225 (class 1259 OID 18274)
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    position_id smallint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 18280)
-- Name: shipments_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipments_history (
    shipment_id bigint NOT NULL,
    shipment_state_id smallint NOT NULL,
    time_inserted timestamp without time zone DEFAULT now() NOT NULL,
    area_id integer NOT NULL
);


ALTER TABLE public.shipments_history OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 18284)
-- Name: shipments_shipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shipments_shipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipments_shipment_id_seq OWNER TO postgres;

--
-- TOC entry 3176 (class 0 OID 0)
-- Dependencies: 227
-- Name: shipments_shipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shipments_shipment_id_seq OWNED BY public.shipments.shipment_id;


--
-- TOC entry 228 (class 1259 OID 18286)
-- Name: shipments_tracking; Type: VIEW; Schema: public; Owner: postgres
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


ALTER TABLE public.shipments_tracking OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 18158)
-- Name: user_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_updates (
    user_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    time_updated timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_updates OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 18176)
-- Name: users_access_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_access_history (
    user_id integer NOT NULL,
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying,
    is_from_mobile boolean
);


ALTER TABLE public.users_access_history OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 18183)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3181 (class 0 OID 0)
-- Dependencies: 208
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 2879 (class 2604 OID 18290)
-- Name: areas area_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas ALTER COLUMN area_id SET DEFAULT nextval('public.areas_area_id_seq'::regclass);


--
-- TOC entry 2881 (class 2604 OID 18291)
-- Name: assignments assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignments ALTER COLUMN assignment_id SET DEFAULT nextval('public.assignments_assignment_id_seq'::regclass);


--
-- TOC entry 2882 (class 2604 OID 18292)
-- Name: cities city_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);


--
-- TOC entry 2893 (class 2604 OID 18294)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 2901 (class 2604 OID 18295)
-- Name: offices office_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices ALTER COLUMN office_id SET DEFAULT nextval('public.offices_office_id_seq'::regclass);


--
-- TOC entry 2896 (class 2604 OID 18296)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 2900 (class 2604 OID 18297)
-- Name: shipments shipment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments ALTER COLUMN shipment_id SET DEFAULT nextval('public.shipments_shipment_id_seq'::regclass);


--
-- TOC entry 2889 (class 2604 OID 18293)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3108 (class 0 OID 18118)
-- Dependencies: 196
-- Data for Name: account_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_types (account_type_id, name, description) FROM stdin;
1	Régulier	\N
2	Professionnel	\N
3	admin	admin user to allow orders manager to create orders
\.


--
-- TOC entry 3109 (class 0 OID 18124)
-- Dependencies: 197
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (contact_name, phone, google_place, description, user_id) FROM stdin;
\.


--
-- TOC entry 3110 (class 0 OID 18130)
-- Dependencies: 198
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- TOC entry 3112 (class 0 OID 18138)
-- Dependencies: 200
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignments (assignment_id, office_id, shipment_id, time_assigned, time_completed) FROM stdin;
\.


--
-- TOC entry 3114 (class 0 OID 18144)
-- Dependencies: 202
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (city_id, name, country_id, office_id) FROM stdin;
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
2	Adjamé	1	8
\.


--
-- TOC entry 3116 (class 0 OID 18152)
-- Dependencies: 204
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (country_id, name) FROM stdin;
1	Côte d'Ivoire
\.


--
-- TOC entry 3121 (class 0 OID 18185)
-- Dependencies: 209
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, first_name, last_name, login, password, active_from, active_to, is_active, position_id, office_id) FROM stdin;
9	Patrice	Lumumba	admin	$2y$12$DC.U2SDcO40IFG4q9NCnme7rwrUqD.ta52ctKwZbw.b/H3Psxr5MK	2019-09-03 10:57:50.38986	\N	t	1	1
10	Soundiata	Keita	willy	$2y$12$DCnfXAwOKEJ26hqDUt3gauLve1WRwIQtRCLm3PK3RF2sllK6Z31LW	2019-09-03 10:59:15.898356	\N	t	2	8
11	Nelson	Mandela	abobo	$2y$12$CqgwDiJZWpIxaieicNoQPuN2CInH/qT3EXVggmGTzWtPgsNIDWvc6	2019-09-03 11:00:08.099668	\N	t	2	2
12	Samori	Touré	michel	$2y$12$NNfQQuiE3u2rbtrEO1ErGenpjpNz/RXczlbI/rMAD7f7ZBTNxr4tW	2019-09-03 11:00:58.461756	\N	t	2	3
13	Toussaint	Louverture	faya	$2y$12$wtAT3ew4O9jw1Md24Se6ROXILP7WMmsHYdps3I.ylyALIvLYnD1t.	2019-09-03 11:01:42.162194	\N	t	2	4
14	Martin	luther king junior	koumassi	$2y$12$I5iHeTEU4OxiUO8oIDMgkOoVm6CZ9eK3/XMAAP2Pf9hoH2sPK/tQu	2019-09-03 11:02:42.525851	\N	t	2	5
15	Malcolm	X	pb	$2y$12$holiDWagT4PPOvXm/F7xFudin1.w8nnwc5C9lNGcQVXPwYq4gEfIu	2019-09-03 11:03:46.161464	\N	t	2	6
16	Marcus	Garvey	yop	$2y$12$wz3HV130vJZ2xeH.qfyKa.YX39b85LPnpNZkVIrlj.NpN0ZAmC2UW	2019-09-03 11:04:40.887634	\N	t	2	7
\.


--
-- TOC entry 3122 (class 0 OID 18193)
-- Dependencies: 210
-- Data for Name: employees_access_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees_access_history (employee_id, access_time, ip_address, is_from_mobile) FROM stdin;
\.


--
-- TOC entry 3130 (class 0 OID 18257)
-- Dependencies: 221
-- Data for Name: offices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offices (office_id, name, address, city_id, manager_id, area_id, longitude, latitude, phone1, phone2) FROM stdin;
3	Agence Plateau	Adjamé, Saint Michel	2	\N	19	-4.025087	5.346901	08983642	54777964
1	Siège social	Adjamé, Williamsville	2	\N	20	-4.018281	5.363538	20370174	09122501
4	Agence Cocody	Cocody, Riviera Faya	4	\N	64	-3.938798	5.369768	07034398	46986882
2	Agence Abobo	Abobo	1	\N	1	-4.016947	5.428508	77315232	54974916
7	Agence Yopougon	Yopougon	6	\N	67	-4.095986	5.343373	49485173	46986609
6	Agence Port-Bouët	Port-Bouët	10	\N	107	-3.978708	5.258663	68053807	45313578
8	Agence Adjamé	Adjamé, Williamsville	2	\N	20	-4.018281	5.363538	09506298	54777978
5	Agence Koumassi	Koumassi, remblais	8	\N	95	-3.967840	5.296436	07059609	54139211
\.


--
-- TOC entry 3124 (class 0 OID 18202)
-- Dependencies: 212
-- Data for Name: order_states; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_states (order_state_id, name, code, description) FROM stdin;
1	En attente de confirmation	PENDING_ORDER	\N
2	En cours de traitement	PROCESSING	\N
3	Terminée	COMPLETED	\N
4	Annulée	CANCELED	\N
\.


--
-- TOC entry 3125 (class 0 OID 18208)
-- Dependencies: 213
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, user_id, time_created, time_closed, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, shipment_category_id, nature, payment_option_id, cost, distance, order_state_id) FROM stdin;
1632345255	57	2019-08-31 12:47:25.919457	\N	KOUAME BEHOUBA 	45001685	64	carrefour abinadair 	Jean Thierry Koffi 	65325821	87	Moscou rue lenine	1	diplôme du bac	2	1250	14.819	2
1632345269	1	2019-09-04 18:10:23.132574	2019-09-04 18:12:25.750593	Ami Chia	22556010	95	gare marche	Sewa Wa	22503482	105	Port bouet phare	2	chaussures	2	1000	5.905	3
1632345254	58	2019-08-28 18:21:44.855206	\N	Marie	45578998	7	VTT kiki re	Yaata	56788899	39	fin je zcg	1	Chaussures	1	1250	14.209	4
1632345273	57	2019-09-06 10:55:56.837234	2019-09-06 12:05:18.788415	Yves Roger 	44689525	75	Banco	jean claude	99352154	114	rue des archanges	1	documents et factures	2	1500	27.234	3
1632345262	58	2019-09-04 12:09:45.329775	2019-09-04 12:12:22.908545	Ai Cha	58759855	28	jbvcdsjklpokjdcsnmx	Ma Riam	02545856	95	rdtfgyh7ujkolpèlkbhj	2	Chaussures et sacs	1	1300	13.962	4
1632345284	58	2019-09-10 12:00:20.130851	2019-09-10 14:51:18.984232	Mana Dja	06587295	87	Trechiville, pharmacie	Dia Blo	85642189	99	Anoumabo, fabrique	2	Sacs	1	1150	7.814	3
1632345277	57	2019-09-06 11:11:22.556248	2019-09-06 12:10:14.099406	Meïté clovis	64598578	54	Blockhauss	Éric zemour	46325879	20	Adjame 	1	Fournitures de bureau 	1	1150	8.047	3
1632345288	58	2019-09-10 15:11:45.738771	\N	Aie aer	04992398	21	Liberté rue 1	Hein heu sien	08596512	8	Abobo Abobo 	2	Sac et écharpes	1	1300	15.106	1
1632345261	1	2019-09-02 17:59:46.235907	2019-09-04 12:24:16.658908	kouame behouba manasse	22 52 25 22	37	angre rue princesss	jean didier	22 52 25 22	5	marcory dokui	2	colis de vetements	1	1150	8.657	3
1632345274	57	2019-09-06 11:01:58.477561	2019-09-06 12:11:58.629585	Brice David 	22653245	99	Anoumabo	Binger Louis 	45785258	112	Port bouet 	2	chaussures	1	1550	25.743	3
1632345272	1	2019-09-04 18:29:01.193533	\N	Aicha soro	05784515	2	abobo	goku	78545856	8	sogefia	1	diplome	1	1000	4.932	4
1632345267	58	2019-09-04 17:43:26.266239	2019-09-04 17:50:09.331313	Ro Ki	84333919	23	mosquée sitarail	Pa Pa	49902912	21	liberté centre nord	1	sac	1	1000	1.22	3
1632345276	57	2019-09-06 11:07:37.868094	2019-09-06 12:13:50.728546	Charles N'dri 	65976495	8	Gare de bassam	Nelson Ali 	65895635	89	Alabama 	1	Documents administratifs	1	1350	19.855	3
1632345265	58	2019-09-04 12:40:46.788774	2019-09-04 17:57:47.666447	Chou Mie	59990049	29	Agban arrêt 14	Ira You	04333319	59	Aghien mosquée	2	Cartons de fripperies	1	1000	6.218	3
1632345271	1	2019-09-04 18:18:29.846134	\N	Fa Tou	22502333	4	akeikoi 2	Mi Chou	22507533	27	habitat 1	1	documents	1	1300	15.236	4
1632345268	1	2019-09-04 18:06:49.335124	2019-09-04 18:08:33.167359	htfvgg	22522522	1	gare marche	jugewu9oh	22522522	98	koumassi nord	2	chaussures	1	1500	23.253	3
1632345270	1	2019-09-04 18:13:25.482352	\N	Ami Chia	22556050	95	gare marche	Sewa Wa	22506231	105	Port bouet phare	1	documents	1	1000	5.905	4
1632345275	57	2019-09-06 11:04:30.816718	2019-09-06 12:15:28.709742	Jean louis 	64563587	115	Anyama 	Moris beats	45631567	66	Rue des banques	1	Factures	2	1450	24.464	3
1632345266	58	2019-09-04 12:52:41.807482	2019-09-06 11:00:20.931475	Bec Ky	09528997	66	Plateau, Avenue Longchamps	Ja Mi	79797875	115	Anyama carrefour IVOSEP	1	Documents administratifs	1	1450	23.338	3
1632345264	58	2019-09-04 12:19:33.813485	2019-09-06 11:04:13.739746	Jean Michel	06132315	95	krfgbnmkc,m njbdb	Gildas Koue	09539997	21	kjhgvsmnbftgyui	1	Documents	1	1250	14.195	3
1632345263	58	2019-09-04 12:14:43.606103	2019-09-06 11:05:04.786653	Chou Mie	59990049	21	adjuaiokkjhdnsm	Ira You	59020105	98	krufioprofihj	1	Documents	1	1250	14.071	3
1632345280	58	2019-09-06 11:21:34.257469	2019-09-06 11:36:51.371945	Ma Pa	75823146	115	gare taxi	Auré Lia	03642589	91	Carrefour CHU	1	Documents	1	1500	25.408	3
1632345279	58	2019-09-06 11:18:38.496434	2019-09-06 11:50:10.328089	Mi Chou	05014068	114	Bingerville, cité Késsé	Chou babe	01023548	115	Anyama carrefour IVOSEP	2	Chaussures et sacs	2	1800	36.216	3
1632345278	58	2019-09-06 11:14:45.154651	2019-09-06 11:52:45.203801	Fat Tou	57164412	65	Cité des arts, Boulevard Françcois-Mitterand Nobert, Cité Lauriers, Villa 49	Iri Na	04333319	49	cocody chateau 	1	Documents	1	1250	12.969	3
1632345281	1	2019-09-06 12:18:03.377442	2019-09-06 12:41:01.984871	Jessi Ca	01759700	66	Plateau, Rue des banques	Awa Bah	04961605	114	Bingerville, lycée garçons	1	Doucuments de bureau	1	1400	21.383	3
1632345287	1	2019-09-10 12:18:16.36402	\N	Soualio Ouatt	02661812	3	Samaké, gare	Zerbo Oumar	56124897	102	bietry dica	2	anti choc	2	1550	23.923	2
1632345283	58	2019-09-09 12:47:29.308943	2019-09-10 14:37:01.947103	Soro	04333919	21	Liberté CIE	Aicha	09531797	66	Plateau avenue Noguès	1	Documents entreprises	1	1000	3.504	3
1632345286	58	2019-09-10 12:09:46.328114	2019-09-10 14:42:07.066696	Aicha Soro	02661812	115	Anyama, rue balsic	Behou Ba	87452365	66	Rue du commerce	1	Documents administratifs	1	1450	24.464	3
1632345282	58	2019-09-08 09:59:48.663695	2019-09-10 14:44:34.532603	fuukoij	04567900	3	t67ioojhv	étuves kk	09885543	72	Zhou gk7gl	1	vêtements	1	1300	16.719	3
1632345285	58	2019-09-10 12:06:14.652106	2019-09-10 14:46:34.957149	Sekou	04338812	85	Sable, derrière la gare	Ira You	04099753	114	Lycée Mamie fêtai 	2	Ordinateur portable	2	1550	24.837	3
\.


--
-- TOC entry 3132 (class 0 OID 18265)
-- Dependencies: 223
-- Data for Name: orders_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_history (order_id, order_state_id, time_created) FROM stdin;
1632345254	1	2019-08-28 18:21:44.858294+00
1632345255	1	2019-08-31 12:47:25.921784+00
1632345255	2	2019-09-02 11:39:27.331556+00
1632345254	4	2019-09-02 17:36:24.191541+00
1632345261	1	2019-09-02 17:59:46.23906+00
1632345262	1	2019-09-04 12:09:45.332377+00
1632345261	2	2019-09-04 12:10:01.392644+00
1632345262	2	2019-09-04 12:10:20.782758+00
1632345262	4	2019-09-04 12:12:22.91096+00
1632345261	4	2019-09-04 12:12:39.657521+00
1632345263	1	2019-09-04 12:14:43.608344+00
1632345263	2	2019-09-04 12:15:23.517205+00
1632345264	1	2019-09-04 12:19:33.816044+00
1632345264	2	2019-09-04 12:19:51.462669+00
1632345265	1	2019-09-04 12:40:46.792753+00
1632345265	2	2019-09-04 12:42:21.661463+00
1632345266	1	2019-09-04 12:52:41.810056+00
1632345266	2	2019-09-04 12:53:19.525448+00
1632345267	1	2019-09-04 17:43:26.268644+00
1632345267	2	2019-09-04 17:43:59.824078+00
1632345268	1	2019-09-04 18:06:49.338769+00
1632345268	2	2019-09-04 18:07:17.120825+00
1632345269	1	2019-09-04 18:10:23.135509+00
1632345269	2	2019-09-04 18:10:49.598043+00
1632345270	1	2019-09-04 18:13:25.485368+00
1632345271	1	2019-09-04 18:18:29.849382+00
1632345272	1	2019-09-04 18:29:01.196788+00
1632345272	4	2019-09-04 18:49:50.219776+00
1632345271	4	2019-09-04 18:50:00.178083+00
1632345270	4	2019-09-04 18:50:09.05802+00
1632345273	1	2019-09-06 10:55:56.840043+00
1632345274	1	2019-09-06 11:01:58.480297+00
1632345275	1	2019-09-06 11:04:30.81904+00
1632345276	1	2019-09-06 11:07:37.870631+00
1632345277	1	2019-09-06 11:11:22.558455+00
1632345278	1	2019-09-06 11:14:45.157265+00
1632345278	2	2019-09-06 11:15:54.409057+00
1632345279	1	2019-09-06 11:18:38.499042+00
1632345279	2	2019-09-06 11:19:25.10026+00
1632345280	1	2019-09-06 11:21:34.259917+00
1632345280	2	2019-09-06 11:22:34.478891+00
1632345273	2	2019-09-06 12:00:56.859614+00
1632345277	2	2019-09-06 12:06:31.47464+00
1632345274	2	2019-09-06 12:10:32.904853+00
1632345276	2	2019-09-06 12:12:39.934827+00
1632345275	2	2019-09-06 12:14:35.129243+00
1632345281	1	2019-09-06 12:18:03.38074+00
1632345281	2	2019-09-06 12:40:08.404267+00
1632345282	1	2019-09-08 09:59:48.665924+00
1632345283	1	2019-09-09 12:47:29.311177+00
1632345284	1	2019-09-10 12:00:20.133105+00
1632345285	1	2019-09-10 12:06:14.654474+00
1632345286	1	2019-09-10 12:09:46.330341+00
1632345282	2	2019-09-10 12:15:09.000511+00
1632345283	2	2019-09-10 12:15:14.531126+00
1632345284	2	2019-09-10 12:15:21.509418+00
1632345285	2	2019-09-10 12:15:25.270316+00
1632345286	2	2019-09-10 12:15:28.841876+00
1632345287	1	2019-09-10 12:18:16.367255+00
1632345287	2	2019-09-10 12:18:42.549076+00
1632345288	1	2019-09-10 15:11:45.741009+00
\.


--
-- TOC entry 3126 (class 0 OID 18216)
-- Dependencies: 214
-- Data for Name: payment_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_options (payment_option_id, name, description) FROM stdin;
1	Paiement au ramassage	Le client paye les frais de livraison au moment de la collecte du colis par le coursier
2	Paiement à la livraison	Le destinataire de colis paye les frais de livraison à la livraison du colis
\.


--
-- TOC entry 3134 (class 0 OID 18274)
-- Dependencies: 225
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (position_id, name, description) FROM stdin;
1	Manager de commandes en ligne	Personne chargée de la gestion de nouvelle commande en ligne, de leur assignation aux agences chargées de la collecte et de la livraison
2	Responsable d'agence	Personne chargée de la gestion de la collecte et de la livraison des colis dans les communes sous la responsabilité de son agence
3	Coursier	Personne chargée de la collecte et de la livraison des colis directement après des clients
\.


--
-- TOC entry 3127 (class 0 OID 18222)
-- Dependencies: 215
-- Data for Name: shipment_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipment_categories (shipment_category_id, name, min_cost, max_cost) FROM stdin;
1	Documents	1000	2000
2	Colis	1000	2300
\.


--
-- TOC entry 3129 (class 0 OID 18241)
-- Dependencies: 218
-- Data for Name: shipment_states; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- TOC entry 3128 (class 0 OID 18228)
-- Dependencies: 216
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipments (shipment_id, order_id, user_id, sender_name, sender_phone, sender_area_id, sender_address, recipient_name, recipient_phone, recipient_area_id, recipient_address, time_created, time_delivered, shipment_category_id, cost, nature, weight, payment_option_id, distance, shipment_state_id, current_office_id) FROM stdin;
1923452359	1632345255	57	KOUAME BEHOUBA 	45001685	64	carrefour abinadair 	Jean Thierry Koffi 	65325821	87	Moscou rue lenine	2019-09-02 11:39:27.326309	\N	1	1250	diplôme du bac	1.5	2	14.819	5	\N
1923452371	1632345279	58	Mi Chou	05014068	114	Bingerville, cité Késsé	Chou babe	01023548	115	Anyama carrefour IVOSEP	2019-09-06 11:19:25.094759	\N	2	1800	Chaussures et sacs	6.3	2	36.216	6	\N
1923452376	1632345276	57	Charles N'dri 	65976495	8	Gare de bassam	Nelson Ali 	65895635	89	Alabama 	2019-09-06 12:12:39.929698	\N	1	1350	Documents administratifs	3	1	19.855	6	\N
1923452369	1632345269	1	Ami Chia	22556010	95	gare marche	Sewa Wa	22503482	105	Port bouet phare	2019-09-04 18:10:49.593405	\N	2	1000	chaussures	9	2	5.905	6	\N
1923452370	1632345278	58	Fat Tou	57164412	65	Cité des arts, Boulevard Françcois-Mitterand Nobert, Cité Lauriers, Villa 49	Iri Na	04333319	49	cocody chateau 	2019-09-06 11:15:54.403936	\N	1	1250	Documents	5	1	12.969	6	\N
1923452361	1632345262	58	Ai Cha	58759855	28	jbvcdsjklpokjdcsnmx	Ma Riam	02545856	95	rdtfgyh7ujkolpèlkbhj	2019-09-04 12:10:20.778755	\N	2	1300	Chaussures et sacs	2	1	13.962	5	\N
1923452360	1632345261	1	kouame behouba manasse	22 52 25 22	37	angre rue princesss	jean didier	22 52 25 22	5	marcory dokui	2019-09-04 12:10:01.387482	\N	2	1150	colis de vetements	9	1	8.657	6	\N
1923452379	1632345282	58	fuukoij	04567900	3	t67ioojhv	étuves kk	09885543	72	Zhou gk7gl	2019-09-10 12:15:08.995375	\N	1	1300	vêtements	0.4	1	16.719	6	\N
1923452366	1632345266	58	Bec Ky	09528997	66	Plateau, Avenue Longchamps	Ja Mi	79797875	115	Anyama carrefour IVOSEP	2019-09-04 12:53:30.928396	\N	1	1450	Documents administratifs	2	1	23.338	6	\N
1923452367	1632345267	58	Ro Ki	84333919	23	mosquée sitarail	Pa Pa	49902912	21	liberté centre nord	2019-09-04 17:43:59.819023	\N	1	1000	sac	6.6	1	1.22	6	\N
1923452365	1632345266	58	Bec Ky	09528997	66	Plateau, Avenue Longchamps	Ja Mi	79797875	115	Anyama carrefour IVOSEP	2019-09-04 12:53:19.519949	\N	1	1450	Documents administratifs	2	1	23.338	6	\N
1923452373	1632345273	57	Yves Roger 	44689525	75	Banco	jean claude	99352154	114	rue des archanges	2019-09-06 12:00:56.85418	\N	1	1500	documents et factures	12	2	27.234	6	\N
1923452380	1632345283	58	Soro	04333919	21	Liberté CIE	Aicha	09531797	66	Plateau avenue Noguès	2019-09-10 12:15:14.527305	\N	1	1000	Documents entreprises	0.5	1	3.504	6	\N
1923452364	1632345265	58	Chou Mie	59990049	29	Agban arrêt 14	Ira You	04333319	59	Aghien mosquée	2019-09-04 12:42:21.656167	\N	2	1000	Cartons de fripperies	3.5	1	6.218	6	\N
1923452363	1632345264	58	Jean Michel	06132315	95	krfgbnmkc,m njbdb	Gildas Koue	09539997	21	kjhgvsmnbftgyui	2019-09-04 12:19:51.457204	\N	1	1250	Documents	5	1	14.195	6	\N
1923452377	1632345275	57	Jean louis 	64563587	115	Anyama 	Moris beats	45631567	66	Rue des banques	2019-09-06 12:14:35.124328	\N	1	1450	Factures	2	2	24.464	6	\N
1923452368	1632345268	1	htfvgg	22522522	1	gare marche	jugewu9oh	22522522	98	koumassi nord	2019-09-04 18:07:17.116266	\N	2	1500	chaussures	8	1	23.253	6	\N
1923452374	1632345277	57	Meïté clovis	64598578	54	Blockhauss	Éric zemour	46325879	20	Adjame 	2019-09-06 12:06:31.469648	\N	1	1150	Fournitures de bureau 	3	1	8.047	6	\N
1923452362	1632345263	58	Chou Mie	59990049	21	adjuaiokkjhdnsm	Ira You	59020105	98	krufioprofihj	2019-09-04 12:15:23.512481	\N	1	1250	Documents	5	1	14.071	6	\N
1923452384	1632345287	1	Soualio Ouatt	02661812	3	Samaké, gare	Zerbo Oumar	56124897	102	bietry dica	2019-09-10 12:18:42.544191	\N	2	1550	anti choc	0.1	2	23.923	5	\N
1923452372	1632345280	58	Ma Pa	75823146	115	gare taxi	Auré Lia	03642589	91	Carrefour CHU	2019-09-06 11:22:34.473883	\N	1	1500	Documents	3	1	25.408	6	\N
1923452375	1632345274	57	Brice David 	22653245	99	Anoumabo	Binger Louis 	45785258	112	Port bouet 	2019-09-06 12:10:32.899788	\N	2	1550	chaussures	6	1	25.743	6	\N
1923452378	1632345281	1	Jessi Ca	01759700	66	Plateau, Rue des banques	Awa Bah	04961605	114	Bingerville, lycée garçons	2019-09-06 12:40:08.39932	\N	1	1400	Doucuments de bureau	7	1	21.383	6	\N
1923452382	1632345285	58	Sekou	04338812	85	Sable, derrière la gare	Ira You	04099753	114	Lycée Mamie fêtai 	2019-09-10 12:15:25.266304	\N	2	1550	Ordinateur portable	2	2	24.837	6	\N
1923452383	1632345286	58	Aicha Soro	02661812	115	Anyama, rue balsic	Behou Ba	87452365	66	Rue du commerce	2019-09-10 12:15:28.837815	\N	1	1450	Documents administratifs	0.2	1	24.464	6	\N
1923452381	1632345284	58	Mana Dja	06587295	87	Trechiville, pharmacie	Dia Blo	85642189	99	Anoumabo, fabrique	2019-09-10 12:15:21.504947	\N	2	1150	Sacs	6.3	1	7.814	6	\N
\.


--
-- TOC entry 3135 (class 0 OID 18280)
-- Dependencies: 226
-- Data for Name: shipments_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipments_history (shipment_id, shipment_state_id, time_inserted, area_id) FROM stdin;
1923452359	1	2019-09-02 11:39:27.3288	64
1923452359	2	2019-09-02 18:14:08.493041	64
1923452359	5	2019-09-02 18:14:26.689578	64
1923452360	1	2019-09-04 12:10:01.389818	37
1923452361	1	2019-09-04 12:10:20.780265	28
1923452362	1	2019-09-04 12:15:23.514533	21
1923452363	1	2019-09-04 12:19:51.459761	95
1923452363	2	2019-09-04 12:20:21.371984	95
1923452363	5	2019-09-04 12:20:30.959038	95
1923452363	4	2019-09-04 12:20:49.826847	20
1923452363	5	2019-09-04 12:21:00.125945	20
1923452360	2	2019-09-04 12:22:47.519618	64
1923452360	5	2019-09-04 12:23:01.185763	64
1923452360	4	2019-09-04 12:24:01.69253	1
1923452360	6	2019-09-04 12:24:16.660094	1
1923452364	1	2019-09-04 12:42:21.658467	29
1923452365	1	2019-09-04 12:53:19.522126	66
1923452366	1	2019-09-04 12:53:30.931208	66
1923452365	2	2019-09-04 12:55:27.578627	19
1923452366	2	2019-09-04 13:00:55.145366	19
1923452365	5	2019-09-04 13:01:03.646404	19
1923452365	4	2019-09-04 13:01:17.586755	1
1923452367	1	2019-09-04 17:43:59.82115	23
1923452367	2	2019-09-04 17:49:45.468083	20
1923452367	6	2019-09-04 17:50:09.332552	20
1923452365	6	2019-09-04 17:53:01.356033	1
1923452364	2	2019-09-04 17:56:24.211114	20
1923452364	5	2019-09-04 17:56:33.83708	20
1923452364	4	2019-09-04 17:57:26.460571	64
1923452364	6	2019-09-04 17:57:47.668047	64
1923452368	1	2019-09-04 18:07:17.118202	1
1923452368	2	2019-09-04 18:07:36.378663	1
1923452368	5	2019-09-04 18:08:11.175849	1
1923452368	4	2019-09-04 18:08:24.846947	95
1923452368	6	2019-09-04 18:08:33.168589	95
1923452369	1	2019-09-04 18:10:49.595367	95
1923452369	2	2019-09-04 18:11:26.226964	95
1923452369	5	2019-09-04 18:11:32.24794	95
1923452369	4	2019-09-04 18:11:53.827471	107
1923452369	7	2019-09-04 18:12:01.727809	107
1923452369	6	2019-09-04 18:12:25.751835	107
1923452361	2	2019-09-06 10:46:35.162654	20
1923452361	5	2019-09-06 10:46:50.019858	20
1923452362	2	2019-09-06 10:49:35.541777	20
1923452366	5	2019-09-06 10:59:32.410533	19
1923452366	4	2019-09-06 10:59:47.910613	1
1923452366	6	2019-09-06 11:00:20.932719	1
1923452363	4	2019-09-06 11:02:51.671105	95
1923452363	5	2019-09-06 11:03:35.806824	95
1923452363	4	2019-09-06 11:03:58.676204	20
1923452363	6	2019-09-06 11:04:13.741403	20
1923452362	5	2019-09-06 11:04:29.355428	20
1923452362	4	2019-09-06 11:04:42.386138	95
1923452362	7	2019-09-06 11:04:49.947104	95
1923452362	6	2019-09-06 11:05:04.787847	95
1923452370	1	2019-09-06 11:15:54.405978	65
1923452371	1	2019-09-06 11:19:25.097245	114
1923452372	1	2019-09-06 11:22:34.476121	115
1923452372	2	2019-09-06 11:29:36.374399	1
1923452372	5	2019-09-06 11:29:44.485289	1
1923452372	4	2019-09-06 11:29:54.516673	95
1923452372	6	2019-09-06 11:36:51.373419	95
1923452371	2	2019-09-06 11:41:57.657049	64
1923452371	5	2019-09-06 11:42:25.105864	64
1923452371	4	2019-09-06 11:42:35.634791	1
1923452371	6	2019-09-06 11:50:10.329352	1
1923452370	2	2019-09-06 11:51:58.449958	64
1923452370	6	2019-09-06 11:52:45.20515	64
1923452373	1	2019-09-06 12:00:56.85659	75
1923452373	2	2019-09-06 12:04:20.067904	67
1923452373	5	2019-09-06 12:04:39.119942	67
1923452373	4	2019-09-06 12:04:49.037291	64
1923452373	6	2019-09-06 12:05:18.78998	64
1923452374	1	2019-09-06 12:06:31.471965	54
1923452374	2	2019-09-06 12:08:47.834725	64
1923452374	5	2019-09-06 12:09:04.70119	64
1923452374	4	2019-09-06 12:09:29.118821	20
1923452374	6	2019-09-06 12:10:14.100602	20
1923452375	1	2019-09-06 12:10:32.902269	99
1923452375	2	2019-09-06 12:11:01.038793	95
1923452375	5	2019-09-06 12:11:06.793855	95
1923452375	4	2019-09-06 12:11:20.898366	107
1923452375	6	2019-09-06 12:11:58.631031	107
1923452376	1	2019-09-06 12:12:39.932063	8
1923452376	2	2019-09-06 12:13:23.870853	1
1923452376	5	2019-09-06 12:13:29.262677	1
1923452376	4	2019-09-06 12:13:41.830405	95
1923452376	6	2019-09-06 12:13:50.730003	95
1923452377	1	2019-09-06 12:14:35.126511	115
1923452377	2	2019-09-06 12:14:51.307611	1
1923452377	5	2019-09-06 12:15:07.700945	1
1923452377	4	2019-09-06 12:15:19.888451	19
1923452377	6	2019-09-06 12:15:28.711082	19
1923452378	1	2019-09-06 12:40:08.40159	66
1923452378	2	2019-09-06 12:40:34.631479	19
1923452378	5	2019-09-06 12:40:43.553386	19
1923452378	4	2019-09-06 12:40:53.204204	64
1923452378	6	2019-09-06 12:41:01.985977	64
1923452379	1	2019-09-10 12:15:08.997888	3
1923452380	1	2019-09-10 12:15:14.528736	21
1923452381	1	2019-09-10 12:15:21.506674	87
1923452382	1	2019-09-10 12:15:25.267822	85
1923452383	1	2019-09-10 12:15:28.839325	115
1923452384	1	2019-09-10 12:18:42.546452	3
1923452380	2	2019-09-10 14:35:26.683019	20
1923452380	5	2019-09-10 14:35:38.12595	20
1923452380	4	2019-09-10 14:36:13.095176	19
1923452380	6	2019-09-10 14:37:01.948553	19
1923452384	2	2019-09-10 14:38:23.394848	1
1923452384	5	2019-09-10 14:38:30.9905	1
1923452383	2	2019-09-10 14:41:36.41087	1
1923452383	5	2019-09-10 14:41:46.828746	1
1923452383	4	2019-09-10 14:41:56.730441	19
1923452383	6	2019-09-10 14:42:07.067901	19
1923452379	2	2019-09-10 14:43:24.589414	1
1923452379	5	2019-09-10 14:43:31.068133	1
1923452379	4	2019-09-10 14:44:04.283999	67
1923452379	6	2019-09-10 14:44:34.534073	67
1923452382	2	2019-09-10 14:45:56.891343	67
1923452382	5	2019-09-10 14:46:06.898762	67
1923452382	4	2019-09-10 14:46:27.800351	64
1923452382	6	2019-09-10 14:46:34.958235	64
1923452381	2	2019-09-10 14:50:54.56813	95
1923452381	6	2019-09-10 14:51:18.985408	95
\.


--
-- TOC entry 3117 (class 0 OID 18158)
-- Dependencies: 205
-- Data for Name: user_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_updates (user_id, first_name, last_name, phone, time_updated) FROM stdin;
57	Behouba Manassé	Kouamé	+225 99 93 10 92	2019-08-28 02:55:00.815909
57	Behouba Manassé	Kouamé	45001685	2019-08-28 03:00:19.516313
57	Behouba Manassé	Kouamé	45001686	2019-08-28 03:00:42.611421
57	Behouba Mana	Kouamé	45001686	2019-08-28 17:39:14.17858
57	Behouba Mana	Kouamé	45001686	2019-08-28 17:39:20.014172
57	Behouba Manassé 	Kouamé	45001686	2019-08-28 17:40:07.735089
57	Behouba Manassé	Kouamé	45001686	2019-08-28 17:40:17.36473
57	Behouba Manassé	Kouamé	45001685	2019-08-29 21:43:18.397771
57	Behouba Manassé	Kouamé	99931092	2019-08-31 12:43:43.730105
57	Behouba Mana	Kouamé	99931092	2019-08-31 12:44:20.194873
57	Behouba Manassé	Kouamé	45001685	2019-08-31 12:44:33.657718
57	Behouba Manassé	Kouamé	45001685	2019-08-31 12:44:59.833718
57	Behouba Manassé	Kouamé	45001685	2019-09-08 07:41:55.917426
57	Behouba Manass	Kouamé	45001685	2019-09-08 07:59:08.780575
\.


--
-- TOC entry 3118 (class 0 OID 18165)
-- Dependencies: 206
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, first_name, last_name, phone, email, password, account_type_id, is_email_verified, is_phone_verified, is_active, recovery_token) FROM stdin;
58	Mie	Chou	59990049	aichasorop@gmail.com	$2a$04$BfbT4ANru9Ek.D0vf6bQpOTQmHeed4cr8NwHYzEJtnhDuC0XZT4Hy	1	f	f	t	\N
1	Akwaba	Express	20370174	contact@akwabaexpress.ci	akwabaexpressisgreat	3	f	f	t	\N
57	Behouba Manassé	Kouamé	45001685	behouba@gmail.com	$2a$04$K/Gk7mYninUUEZvrNw.0Uu/JIdcQnECdaG6Z.5Ek0IDqvSUwktKWG	1	f	f	t	$2a$10$kPFdRqR6og/9mDrMH1TdrOb/yRqYhF9584ZgcK87ivVY8wZ6CjzXW
\.


--
-- TOC entry 3119 (class 0 OID 18176)
-- Dependencies: 207
-- Data for Name: users_access_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_access_history (user_id, access_time, ip_address, is_from_mobile) FROM stdin;
57	2019-08-28 01:15:13.088448	127.0.0.1	\N
57	2019-08-28 02:10:41.776597	127.0.0.1	\N
57	2019-08-28 02:14:03.23573	127.0.0.1	\N
57	2019-08-28 02:54:34.017864	127.0.0.1	\N
57	2019-08-28 03:01:19.149807	127.0.0.1	\N
57	2019-08-28 10:03:43.071448	127.0.0.1	\N
57	2019-08-28 14:40:27.50475	127.0.0.1	\N
57	2019-08-28 17:36:23.771365	127.0.0.1	\N
57	2019-08-28 17:38:50.757781	127.0.0.1	\N
57	2019-08-29 00:44:09.194648	127.0.0.1	\N
57	2019-08-29 15:00:26.797696	127.0.0.1	\N
57	2019-08-29 19:32:11.475058	127.0.0.1	\N
57	2019-08-31 12:39:29.735755	127.0.0.1	\N
57	2019-09-03 13:41:25.050794	127.0.0.1	\N
57	2019-09-03 13:43:57.119867	127.0.0.1	\N
57	2019-09-03 14:49:26.636281	127.0.0.1	\N
57	2019-09-03 17:24:28.177078	127.0.0.1	\N
57	2019-09-03 18:10:28.062863	127.0.0.1	\N
57	2019-09-03 21:17:47.271194	127.0.0.1	\N
58	2019-09-04 12:08:26.508433	127.0.0.1	\N
58	2019-09-04 12:26:49.044344	127.0.0.1	\N
57	2019-09-04 12:40:03.846388	127.0.0.1	\N
57	2019-09-04 13:29:55.252973	127.0.0.1	\N
58	2019-09-04 17:41:57.326065	127.0.0.1	\N
57	2019-09-06 10:54:41.654143	127.0.0.1	\N
57	2019-09-06 11:17:02.491377	127.0.0.1	\N
57	2019-09-06 18:30:50.442897	127.0.0.1	\N
58	2019-09-08 09:58:44.468018	127.0.0.1	\N
57	2019-09-09 05:05:10.742221	127.0.0.1	\N
57	2019-09-09 17:41:33.315437	127.0.0.1	\N
57	2019-09-10 05:48:02.086891	127.0.0.1	\N
58	2019-09-10 15:10:40.205022	127.0.0.1	\N
\.


--
-- TOC entry 3183 (class 0 OID 0)
-- Dependencies: 199
-- Name: areas_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.areas_area_id_seq', 115, true);


--
-- TOC entry 3184 (class 0 OID 0)
-- Dependencies: 201
-- Name: assignments_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assignments_assignment_id_seq', 1, false);


--
-- TOC entry 3185 (class 0 OID 0)
-- Dependencies: 203
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 12, true);


--
-- TOC entry 3186 (class 0 OID 0)
-- Dependencies: 211
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 16, true);


--
-- TOC entry 3187 (class 0 OID 0)
-- Dependencies: 222
-- Name: offices_office_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.offices_office_id_seq', 8, true);


--
-- TOC entry 3188 (class 0 OID 0)
-- Dependencies: 224
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 1632345288, true);


--
-- TOC entry 3189 (class 0 OID 0)
-- Dependencies: 227
-- Name: shipments_shipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shipments_shipment_id_seq', 1923452384, true);


--
-- TOC entry 3190 (class 0 OID 0)
-- Dependencies: 208
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 58, true);


--
-- TOC entry 2905 (class 2606 OID 18299)
-- Name: account_types account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (account_type_id);


--
-- TOC entry 2907 (class 2606 OID 18301)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (contact_name, phone, google_place, description, user_id);


--
-- TOC entry 2909 (class 2606 OID 18303)
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area_id);


--
-- TOC entry 2911 (class 2606 OID 18305)
-- Name: cities cities_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_name_key UNIQUE (name);


--
-- TOC entry 2913 (class 2606 OID 18307)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 2915 (class 2606 OID 18309)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- TOC entry 2923 (class 2606 OID 18317)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 2945 (class 2606 OID 18319)
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (office_id);


--
-- TOC entry 2947 (class 2606 OID 18321)
-- Name: orders_history order_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_pkey PRIMARY KEY (order_id, order_state_id);


--
-- TOC entry 2925 (class 2606 OID 18323)
-- Name: order_states order_states_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_code_key UNIQUE (code);


--
-- TOC entry 2927 (class 2606 OID 18325)
-- Name: order_states order_states_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_name_key UNIQUE (name);


--
-- TOC entry 2929 (class 2606 OID 18327)
-- Name: order_states order_states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_states
    ADD CONSTRAINT order_states_pkey PRIMARY KEY (order_state_id);


--
-- TOC entry 2931 (class 2606 OID 18329)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 2933 (class 2606 OID 18331)
-- Name: payment_options payment_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_options
    ADD CONSTRAINT payment_options_pkey PRIMARY KEY (payment_option_id);


--
-- TOC entry 2949 (class 2606 OID 18333)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- TOC entry 2935 (class 2606 OID 18335)
-- Name: shipment_categories shipment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_categories
    ADD CONSTRAINT shipment_categories_pkey PRIMARY KEY (shipment_category_id);


--
-- TOC entry 2939 (class 2606 OID 18337)
-- Name: shipment_states shipment_states_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_code_key UNIQUE (code);


--
-- TOC entry 2941 (class 2606 OID 18339)
-- Name: shipment_states shipment_states_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_name_key UNIQUE (name);


--
-- TOC entry 2943 (class 2606 OID 18341)
-- Name: shipment_states shipment_states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipment_states
    ADD CONSTRAINT shipment_states_pkey PRIMARY KEY (shipment_state_id);


--
-- TOC entry 2937 (class 2606 OID 18343)
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (shipment_id);


--
-- TOC entry 2917 (class 2606 OID 18311)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 2919 (class 2606 OID 18313)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 2921 (class 2606 OID 18315)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2950 (class 2606 OID 18344)
-- Name: addresses addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2951 (class 2606 OID 18349)
-- Name: areas areas_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id);


--
-- TOC entry 2952 (class 2606 OID 18354)
-- Name: assignments assignments_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2953 (class 2606 OID 18359)
-- Name: cities cities_contry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_contry_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2954 (class 2606 OID 18364)
-- Name: cities cities_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id);


--
-- TOC entry 2960 (class 2606 OID 18384)
-- Name: employees_access_history employees_access_history_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees_access_history
    ADD CONSTRAINT employees_access_history_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 2958 (class 2606 OID 18389)
-- Name: employees employees_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.offices(office_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2959 (class 2606 OID 18394)
-- Name: employees employees_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2975 (class 2606 OID 18399)
-- Name: offices offices_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2976 (class 2606 OID 18404)
-- Name: offices offices_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2977 (class 2606 OID 18409)
-- Name: offices offices_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 2978 (class 2606 OID 18414)
-- Name: orders_history order_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 2979 (class 2606 OID 18419)
-- Name: orders_history order_history_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_history
    ADD CONSTRAINT order_history_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_states(order_state_id);


--
-- TOC entry 2962 (class 2606 OID 18429)
-- Name: orders orders_order_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_state_id_fkey FOREIGN KEY (order_state_id) REFERENCES public.order_states(order_state_id);


--
-- TOC entry 2963 (class 2606 OID 18434)
-- Name: orders orders_payment_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_payment_option_id_fkey FOREIGN KEY (payment_option_id) REFERENCES public.payment_options(payment_option_id);


--
-- TOC entry 2964 (class 2606 OID 18439)
-- Name: orders orders_recipient_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_recipient_area_id_fkey FOREIGN KEY (recipient_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2965 (class 2606 OID 18444)
-- Name: orders orders_sender_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_sender_area_id_fkey FOREIGN KEY (sender_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2966 (class 2606 OID 18449)
-- Name: orders orders_shipment_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_shipment_category_id_fkey FOREIGN KEY (shipment_category_id) REFERENCES public.shipment_categories(shipment_category_id);


--
-- TOC entry 2961 (class 2606 OID 18424)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2980 (class 2606 OID 18459)
-- Name: shipments_history shipments_history_shipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT shipments_history_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments(shipment_id);


--
-- TOC entry 2968 (class 2606 OID 18464)
-- Name: shipments shipments_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_office_id_fkey FOREIGN KEY (current_office_id) REFERENCES public.offices(office_id);


--
-- TOC entry 2969 (class 2606 OID 18469)
-- Name: shipments shipments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 2970 (class 2606 OID 18474)
-- Name: shipments shipments_payment_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_payment_option_id_fkey FOREIGN KEY (payment_option_id) REFERENCES public.payment_options(payment_option_id);


--
-- TOC entry 2971 (class 2606 OID 18479)
-- Name: shipments shipments_recipient_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_recipient_area_id_fkey FOREIGN KEY (recipient_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2972 (class 2606 OID 18484)
-- Name: shipments shipments_sender_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_sender_area_id_fkey FOREIGN KEY (sender_area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2973 (class 2606 OID 18489)
-- Name: shipments shipments_shipment_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_category_id_fkey FOREIGN KEY (shipment_category_id) REFERENCES public.shipment_categories(shipment_category_id);


--
-- TOC entry 2974 (class 2606 OID 18494)
-- Name: shipments shipments_shipment_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_state_id_fkey FOREIGN KEY (shipment_state_id) REFERENCES public.shipment_states(shipment_state_id);


--
-- TOC entry 2967 (class 2606 OID 18454)
-- Name: shipments shipments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2981 (class 2606 OID 18499)
-- Name: shipments_history trackings_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT trackings_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- TOC entry 2982 (class 2606 OID 18504)
-- Name: shipments_history trackings_shipment_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments_history
    ADD CONSTRAINT trackings_shipment_state_id_fkey FOREIGN KEY (shipment_state_id) REFERENCES public.shipment_states(shipment_state_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2955 (class 2606 OID 18369)
-- Name: user_updates user_updates_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_updates
    ADD CONSTRAINT user_updates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2957 (class 2606 OID 18374)
-- Name: users_access_history users_access_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_access_history
    ADD CONSTRAINT users_access_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2956 (class 2606 OID 18379)
-- Name: users users_account_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_account_type_id_fkey FOREIGN KEY (account_type_id) REFERENCES public.account_types(account_type_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE account_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.account_types TO website;
GRANT ALL ON TABLE public.account_types TO adminapi;


--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE addresses; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.addresses TO website;
GRANT ALL ON TABLE public.addresses TO adminapi;


--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE areas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.areas TO website;
GRANT ALL ON TABLE public.areas TO adminapi;


--
-- TOC entry 3146 (class 0 OID 0)
-- Dependencies: 199
-- Name: SEQUENCE areas_area_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.areas_area_id_seq TO website;
GRANT ALL ON SEQUENCE public.areas_area_id_seq TO adminapi;


--
-- TOC entry 3147 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE assignments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.assignments TO website;
GRANT ALL ON TABLE public.assignments TO adminapi;


--
-- TOC entry 3149 (class 0 OID 0)
-- Dependencies: 201
-- Name: SEQUENCE assignments_assignment_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.assignments_assignment_id_seq TO website;
GRANT ALL ON SEQUENCE public.assignments_assignment_id_seq TO adminapi;


--
-- TOC entry 3150 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE cities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cities TO website;
GRANT ALL ON TABLE public.cities TO adminapi;


--
-- TOC entry 3152 (class 0 OID 0)
-- Dependencies: 203
-- Name: SEQUENCE cities_city_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cities_city_id_seq TO website;
GRANT ALL ON SEQUENCE public.cities_city_id_seq TO adminapi;


--
-- TOC entry 3153 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO website;
GRANT ALL ON TABLE public.countries TO adminapi;


--
-- TOC entry 3154 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE employees; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.employees TO website;
GRANT ALL ON TABLE public.employees TO adminapi;


--
-- TOC entry 3155 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE employees_access_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.employees_access_history TO website;
GRANT ALL ON TABLE public.employees_access_history TO adminapi;


--
-- TOC entry 3157 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE employees_employee_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.employees_employee_id_seq TO website;
GRANT ALL ON SEQUENCE public.employees_employee_id_seq TO adminapi;


--
-- TOC entry 3158 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE order_states; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.order_states TO website;
GRANT ALL ON TABLE public.order_states TO adminapi;


--
-- TOC entry 3159 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orders TO website;
GRANT ALL ON TABLE public.orders TO adminapi;


--
-- TOC entry 3160 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE payment_options; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payment_options TO website;
GRANT ALL ON TABLE public.payment_options TO adminapi;


--
-- TOC entry 3161 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE shipment_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shipment_categories TO website;
GRANT ALL ON TABLE public.shipment_categories TO adminapi;


--
-- TOC entry 3162 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE shipments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shipments TO website;
GRANT ALL ON TABLE public.shipments TO adminapi;


--
-- TOC entry 3163 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE full_orders; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.full_orders TO website;
GRANT ALL ON TABLE public.full_orders TO adminapi;


--
-- TOC entry 3164 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE shipment_states; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shipment_states TO website;
GRANT ALL ON TABLE public.shipment_states TO adminapi;


--
-- TOC entry 3165 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE full_shipments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.full_shipments TO website;
GRANT ALL ON TABLE public.full_shipments TO adminapi;


--
-- TOC entry 3166 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO website;
GRANT ALL ON TABLE public.users TO adminapi;


--
-- TOC entry 3167 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE mailing_data_view; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.mailing_data_view TO website;
GRANT ALL ON TABLE public.mailing_data_view TO adminapi;


--
-- TOC entry 3168 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE offices; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.offices TO website;
GRANT ALL ON TABLE public.offices TO adminapi;


--
-- TOC entry 3170 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE offices_office_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.offices_office_id_seq TO website;
GRANT ALL ON SEQUENCE public.offices_office_id_seq TO adminapi;


--
-- TOC entry 3171 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE orders_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orders_history TO website;
GRANT ALL ON TABLE public.orders_history TO adminapi;


--
-- TOC entry 3173 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE orders_order_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.orders_order_id_seq TO website;
GRANT ALL ON SEQUENCE public.orders_order_id_seq TO adminapi;


--
-- TOC entry 3174 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE positions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.positions TO website;
GRANT ALL ON TABLE public.positions TO adminapi;


--
-- TOC entry 3175 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE shipments_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shipments_history TO website;
GRANT ALL ON TABLE public.shipments_history TO adminapi;


--
-- TOC entry 3177 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE shipments_shipment_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.shipments_shipment_id_seq TO website;
GRANT ALL ON SEQUENCE public.shipments_shipment_id_seq TO adminapi;


--
-- TOC entry 3178 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE shipments_tracking; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shipments_tracking TO website;
GRANT ALL ON TABLE public.shipments_tracking TO adminapi;


--
-- TOC entry 3179 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE user_updates; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_updates TO website;
GRANT ALL ON TABLE public.user_updates TO adminapi;


--
-- TOC entry 3180 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE users_access_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users_access_history TO website;
GRANT ALL ON TABLE public.users_access_history TO adminapi;


--
-- TOC entry 3182 (class 0 OID 0)
-- Dependencies: 208
-- Name: SEQUENCE users_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_user_id_seq TO website;
GRANT ALL ON SEQUENCE public.users_user_id_seq TO adminapi;


-- Completed on 2019-09-10 19:37:04 MSK

--
-- PostgreSQL database dump complete
--

