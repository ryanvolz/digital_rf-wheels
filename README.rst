########################################
Building and uploading digital_rf wheels
########################################

The purpose of this repository is to automate wheel building for `digital_rf <https://github.com/MITHaystack/digital_rf>`_ based on a PyPI source package release. This functionality is enabled by using the `multibuild <https://github.com/matthew-brett/multibuild>`_ project to create Linux, OSX, and Windows wheels using Travis CI and AppVeyor infrastructure.

Current build status
====================

Linux/OSX: |Travis|_
Windows: |AppVeyor|_

.. |Travis| image:: https://travis-ci.org/ryanvolz/digital_rf-wheels.svg?branch=master
.. _Travis: https://travis-ci.org/ryanvolz/digital_rf-wheels

.. |AppVeyor| image:: https://ci.appveyor.com/api/projects/status/k0hp80vi1qeo2uqq/branch/master?svg=true
.. _AppVeyor: https://ci.appveyor.com/project/ryanvolz/digital-rf-wheels

Current wheels
==============

PyPI: |PyPI|_

.. |PyPI| image:: https://badge.fury.io/py/digital-rf.svg
.. _PyPI: https://pypi.python.org/pypi/digital-rf/

How it works
============

Any commit to this repository will trigger a new build. You will likely want to edit the ``.travis.yml`` and ``.appveyor.yml`` files and update the ``PROJECT_SPEC`` variable to point to a new PyPI source release. Wheels will be automatically uploaded to PyPI when a build succeeds and there is no existing wheel. It is necessary to securely set the ``TWINE_USERNAME`` and ``TWINE_PASSWORD`` variables in the CI project settings for Travis and AppVeyor in order for that to work.
