use serde::{Deserialize, Serialize};
use chrono::NaiveDate;

#[derive(Deserialize, Debug, Default)]

pub struct FilterOptions {
    pub page: Option<usize>,
    pub limit: Option<usize>,
}

#[derive(Deserialize, Debug)]
pub struct ParamOptions {
    pub id: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CreateNoteSchema {
    pub title: String,
    pub content: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub category: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub published: Option<bool>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UpdateNoteSchema {
    pub title: Option<String>,
    pub content: Option<String>,
    pub category: Option<String>,
    pub published: Option<bool>,
}

pub struct CreateCaseSchema {
    pub case_number: String,
    pub title: String,
    pub filing_date: NaiveDate,
    pub case_status: String, // Consider using an Enum for status
    pub courtroom_id: Option<String>,
    pub scheduled_date: Option<chrono::NaiveDateTime>
}

// UpdateCaseSchema represents the data that can be updated for a case.
#[derive(Debug, Serialize, Deserialize)]
pub struct UpdateCaseSchema {
    pub case_number: String,
    pub title: String,
    pub filing_date: Option<String>,
    pub case_status: String, // Consider using an Enum for status
    pub courtroom_id: Option<String>,
    pub scheduled_date: Option<String>
}
