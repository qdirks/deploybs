if not exist packages cd browser-sync
if not exist packages (
    cd %~dp0
    if not exist browser-sync (
        git clone https://github.com/qdirks/browser-sync.git
    )
    cd browser-sync
)