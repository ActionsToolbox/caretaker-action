FROM wolfsoftwareltd/caretaker:0.0.5

COPY LICENSE.md README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
