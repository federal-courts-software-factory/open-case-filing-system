// use Option<chrono::DateTime<chrono::Utc>>Time;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

#[derive(Debug, FromRow, Deserialize, Serialize)]
#[allow(non_snake_case)]
pub struct NoteModel {
    pub id: Uuid,
    pub title: String,
    pub content: String,
    pub category: Option<String>,
    pub published: Option<bool>,
    #[serde(rename = "createdAt")]
    pub created_at: Option<chrono::DateTime<chrono::Utc>>,
    #[serde(rename = "updatedAt")]
    pub updated_at: Option<chrono::DateTime<chrono::Utc>>
}


#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Role {
    pub id: Uuid,
    pub name: String,
    pub description: Option<String>,
    pub published: bool,
    pub created_at: Option<chrono::DateTime<chrono::Utc>>,
    pub updated_at: Option<chrono::DateTime<chrono::Utc>>,
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub password_hash: String,
    pub email: String,
    pub role_id: Option<Uuid>,
    pub created_at: Option<chrono::DateTime<chrono::Utc>>,
    pub last_login: Option<chrono::DateTime<chrono::Utc>>,
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct CaseModel {
    pub id: Uuid,
    pub case_number: Option<String>,
    pub title: Option<String>,
    pub filing_date: Option<chrono::DateTime<chrono::Utc>>,
    pub status: String, // Consider using an Enum for status
    pub courtroom_id: Option<Uuid>,
    pub scheduled_date: Option<chrono::DateTime<chrono::Utc>>,
    pub last_modified_by: Option<Uuid>,
    pub last_modified_date: Option<chrono::DateTime<chrono::Utc>>,

}



#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Courtroom {
    pub id: Uuid,
    pub name: String,
    pub location: String,
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Judge {
    pub id: Uuid,
    pub title: String,
    pub firstname: String,
    pub lastname: String,
    pub appointment_date: Option<chrono::DateTime<chrono::Utc>>,
    pub district: String,
    // Add address_id if you include the address relationship
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Lawyer {
    pub id: Uuid,
    pub firstname: String,
    pub lastname: String,
    pub bar_number: String,
    pub law_firm_id: Option<Uuid>,
    // Add address_id if you include the address relationship
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Party {
    pub id: Uuid,
    pub name: String,
    pub party_type: String, // Consider using an Enum
    pub representation_id: Uuid,
    // Add address_id if you include the address relationship
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Document {
    pub id: Uuid,
    pub case_id: Uuid,
    pub title: String,
    pub description: String,
    pub file_path: String,
    pub submitted_by: Uuid,
    pub submission_date: Option<chrono::DateTime<chrono::Utc>>
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Hearing {
    pub id: Uuid,
    pub case_id: Uuid,
    pub date: Option<chrono::DateTime<chrono::Utc>>,
    pub judge_id: Uuid,
    pub courtroom_id: Uuid
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct HearingDetail {
    pub id: Uuid,
    pub hearing_id: Uuid,
    pub detail: String,
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct CourtEvent {
    pub id: Uuid,
    pub case_id: Uuid,
    pub title: String,
    pub description: String,
    pub event_date: Option<chrono::DateTime<chrono::Utc>>,
    pub created_by: Uuid,
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct CaseNote {
    pub id: Uuid,
    pub case_id: Uuid,
    pub note: String,
    pub created_by: Uuid,
    pub created_at: Option<chrono::DateTime<chrono::Utc>>
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Task {
    pub id: Uuid,
    pub case_id: Uuid,
    pub title: String,
    pub description: String,
    pub due_date: Option<chrono::DateTime<chrono::Utc>>,
    pub assigned_to: Uuid,
    pub status: String, // Consider using an Enum
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct Notification {
    pub id: Uuid,
    pub user_id: Uuid,
    pub message: String,
    pub created_at: Option<chrono::DateTime<chrono::Utc>>,
    pub read: bool,
}

#[derive(Debug, sqlx::FromRow, Serialize, Deserialize)]
pub struct FinancialTransaction {
    pub id: Uuid,
    pub case_id: Uuid,
    pub amount: f64,
    pub transaction_date: Option<chrono::DateTime<chrono::Utc>>,
    pub description: String,
}

