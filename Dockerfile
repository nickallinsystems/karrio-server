FROM karrio/server:2026.1.32

ENV ALLOWED_HOSTS=*
ENV KARRIO_HTTP_PORT=5002

RUN pip install --no-cache-dir karrio.shipengine==2026.1.32

# Patch broken migration 0078: MODELS variable is undefined when import fails
# In 2026.1.x the import path no longer exists, so set MODELS to empty dict
RUN python3 -c "\
import pathlib; \
p = pathlib.Path('/karrio/venv/lib/python3.12/site-packages/karrio/server/providers/migrations/0078_auto_20240813_1552.py'); \
t = p.read_text(); \
t = t.replace('    except ImportError:\n        pass', '    except ImportError:\n        MODELS = {}'); \
p.write_text(t); \
print('Patched migration 0078 successfully')"

CMD ["./entrypoint"]
