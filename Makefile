# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

all:  compile

config.erl:
	@echo "Apache CouchDB has not been configured."
	@echo "Try \"./configure -h\" for help."
	@echo
	@false

compile: config.erl
	@echo "==> couchjs (compile)"
	@rebar compile

clean:
	@echo "==> couchjs (clean)"
	@rebar clean

check: eunit


dist: compile
	@rm -rf rel/couchdb
	@rebar generate

distclean: clean
	@rm -rf rel/couchdb

include install.mk
install: dist
	@mkdir -p $(prefix)
	@cp -R rel/couchdb/* $(prefix)
	@mkdir -p $(data_dir)
	@chown $(user) $(data_dir)
	@mkdir -p $(view_index_dir)
	@chown $(user) $(view_index_dir)
	@touch $(prefix)/var/log/couchdb.log
	@chown $(user) $(prefix)/var/log/couchdb.log

install.mk:
	@echo "No install.mk found. Run ./configure"
	@exit 1

docker:
	@docker build --no-cache --rm -t couchdb/dev-cluster .

eunit:
	@rebar eunit skip_deps=meck,mochiweb,lager
