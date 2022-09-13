FROM wolfsoftwareltd/caretaker

COPY LICENSE.md README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
