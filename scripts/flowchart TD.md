flowchart TD
    A(Request - Name) -->|Request OK| B(Get Institution Setup Type)
    B --> C{Setup Type Found}
    C -->|Yes| D(Get Soundex Configuration)
    C -->|No| Z(Email to Institution)
    D --> E{Found Soundex Configuration}
    E -->|Yes| F(Map SoundEx Data)
    E -->|No| G(Add Soundex Message)
    F --> H(Success OK) --> Z
    G --> I(Success OK) --> Z
    J[Found Institution Setup] --> C
    K{Soundex (Soundex, LexisNexis, etc)} --> J
    E --> L(Post Soundex)
    L --> M(Store Soundex Request)
    M --> N{Stored OK}
    N -->|Yes| O(Needs Decision) --> P(Send Email)
    P --> Q(Store Response)
    O -->|No| Z