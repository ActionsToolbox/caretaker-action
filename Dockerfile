FROM wolfsoftwareltd/caretaker

LABEL org.opencontainers.image.authors='Wolf Software <containers@wolfsoftare.com>'
LABEL org.opencontainers.image.vendor='Wolf Software'
LABEL org.opencontainers.image.licenses='MIT'
LABEL org.opencontainers.image.title='Caretaker GitHub Action'
LABEL org.opencontainers.image.description='Caretkaer GitHub Action'
LABEL org.opencontainers.image.created="$(date --rfc-3339=seconds --utc)"
LABEL org.opencontainers.image.source='https://github.com/ActionsToolbox/caretaker-action'
LABEL org.opencontainers.image.documentation='https://github.com/ActionsToolbox/caretaker-action'

COPY LICENSE.md README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
