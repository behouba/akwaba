package employees

const dbSchema = `
CREATE TABLE IF NOT EXISTS positions (
    position character varying NOT NULL PRIMARY KEY,
    description character varying
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    login character varying,
    password character varying,
    active_from timestamp without time zone DEFAULT now() NOT NULL,
    active_to timestamp without time zone,
    is_active boolean DEFAULT true NOT NULL,
    position character varying NOT NULL REFERENCES positions(position),
	office character varying NOT NULL
);

CREATE TABLE IF NOT EXISTS access_history (
    employee_id integer NOT NULL REFERENCES employees(employee_id),
    access_time timestamp without time zone DEFAULT now() NOT NULL,
    ip character varying,
);
`

const (
	selectOrdersManagerSQL  = `SELECT first_name, last_name, password, office FROM employees WHERE login=$1 AND is_active=true AND position_id=` + "OrdersManagerPositionID"
	selectParcelsManagerSQL = `SELECT first_name, last_name, password, office FROM employees WHERE login=$1 AND is_active=true AND position_id=` + "ParcelsManagerPositionID"
	insertAccessHistorySQL  = "INSERT INTO access_history (employee_id, ip) VALUES ($1, $2)"
)

// CREATE TABLE offices (
//     office_id integer NOT NULL,
//     name character varying NOT NULL,
//     address character varying,
//     city_id integer NOT NULL,
//     manager_id integer,
//     area_id integer NOT NULL,
//     longitude numeric,
//     latitude numeric,
//     phone1 character varying,
//     phone2 character varying
// );

type statments struct {
}
