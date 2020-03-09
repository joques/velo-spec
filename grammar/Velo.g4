grammar Velo;

/*
 * Parser Rules
 */

velo: author NL orchestration NL? EOF;
author: AUTHOR EQUAL BASIC_STRING;
orchestration: svBag | mvBag;
svBag:
	sBagHeader NL applicationId NL (instances NL)? (cmd NL)? (
		cpus NL
	)? (disk NL)? (memory NL)? (acceptedResourceRoles NL)? (
		args NL
	)? (backoffFactor NL)? (backoffSeconds NL)? (dependencies NL)? (
		executor NL
	)? (maxLaunchDelay NL)? (requirePorts NL)? (user NL)? (
		version NL
	)? (taskKillGracePeriod NL)? (tty NL)? container NL envs? labels? (
		upgradeStrategy NL
	)? (secrets NL)? (healthChecks NL)* (readinessChecks NL)* portDefinitions* (
		fetch NL
	)*;
sBagHeader: OPENBR 'svBag' CLOSINGBR;
acceptedResourceRoles: ACCEPTEDROLES EQUAL str_array;
args: ARGS EQUAL str_array;
backoffSeconds: BACKOFFSECS EQUAL (DEC_INT | FLOAT);
check:
	checkTable NL delaySeconds NL exec NL intervalSeconds NL timeoutSeconds NL checkHttp;
checkTable: OPENBR 'mvBag.containers.check' CLOSINGBR;
delaySeconds: DELAYSEC EQUAL (DEC_INT | FLOAT);
intervalSeconds: INTERVALSEC EQUAL (DEC_INT | FLOAT);
timeoutSeconds: TIMEMOUTSEC EQUAL (DEC_INT | FLOAT);
checkHttp: httpTable NL path NL portIndex NL scheme NL checkTcp;
httpTable: OPENBR 'mvBag.containers.check.http' CLOSINGBR;
path: PATH EQUAL BASIC_STRING;
portIndex: PORTINDEX EQUAL (DEC_INT | FLOAT);
scheme: SCHEME EQUAL BASIC_STRING;
checkTcp: checkTcpTable NL portIndex;
checkTcpTable: OPENBR 'mvBag.containers.check.tcp' CLOSINGBR;
cmd: CMD EQUAL BASIC_STRING;
dependencies: DEPENDENCIES EQUAL str_array;
envs: envTable NL (keyValueStr NL)*;
envTable: OPENBR OPENBR 'svBag.env' CLOSINGBR CLOSINGBR;
executor: EXECUTOR EQUAL BASIC_STRING;
executorResources:
	executorResourcesTable NL cpu NL disk NL resourceMemory;
executorResourcesTable:
	OPENBR 'svBag.executorResources' CLOSINGBR;
fetch: fetchTable NL uri;
fetchTable: OPENBR OPENBR 'svBag.fetch' CLOSINGBR CLOSINGBR;
labels: labelsTable NL (keyValueStr NL)*;
labelsTable: OPENBR OPENBR 'svBag.labels' CLOSINGBR CLOSINGBR;
gpus: GPUS EQUAL (DEC_INT | FLOAT);
applicationId: ID EQUAL BASIC_STRING;
healthChecks:
	healthChecksTable NL gracePeriodSeconds NL ignoreHttp NL intervalSeconds NL
		maxConsecutiveFailures NL path NL portIndex NL protocol NL timeoutSeconds;
healthChecksTable:
	OPENBR OPENBR 'svBag.healthChecks' CLOSINGBR CLOSINGBR;
instances: INSTANCES EQUAL DEC_INT;
killSelection: KILLSELECTION EQUAL KILLTYPE;
ports: PORTS EQUAL int_array;
readinessChecks:
	readinessChecksTable NL name NL protocol NL path NL portName NL intervalSeconds NL
		timeoutSeconds NL readyStatusCodes NL preserveLastResponse;
readinessChecksTable:
	OPENBR OPENBR 'svBag.readinessChecks' CLOSINGBR CLOSINGBR;
portName: PORTNAME EQUAL BASIC_STRING;
readyStatusCodes: HTTPREADYSTATUSCODES EQUAL int_array;
preserveLastResponse: PRESERVELASTRESPONSE EQUAL BOOLEAN;
requirePorts: REQUIREPORTS EQUAL BOOLEAN;
secrets: secretsTable NL (secretTable NL source)*;
secretsTable: OPENBR OPENBR 'svBag.secrets' CLOSINGBR CLOSINGBR;
secretTable: OPENBR 'svBag.secrets.' UNQUOTED_KEY CLOSINGBR;
source: SOURCE EQUAL BASIC_STRING NL?;
user: USER EQUAL BASIC_STRING;
upgradeStrategy:
	upgradeStrategyTable NL maximumOverCapacity NL minimumHealthCapacity;
upgradeStrategyTable: OPENBR 'svBag.upgradeStrategy' CLOSINGBR;
maximumOverCapacity: MAXIMUMOVERCAPACITY EQUAL DEC_INT;
minimumHealthCapacity: MINIMUMHEALTHCAPACITY EQUAL DEC_INT;
version: VERSION EQUAL BASIC_STRING;
taskKillGracePeriod: TASKKILLGRACEPERIODSECONDS EQUAL DEC_INT;
container:
	conatinerHeader NL (credential NL)? (forcePullImage NL)? image NL (
		restartPolicy NL
	)? (network NL)? (privileged NL)? singleContainerLabels? parameters? (
		portMapping NL
	)* (pullConfig NL)? (volumes NL)* commands*;
conatinerHeader: OPENBR 'svBag.container' CLOSINGBR;
forcePullImage: FORCEPULLIMAGE EQUAL BOOLEAN;
singleContainerLabels:
	singleContainerLabelsTable NL (keyValueStr NL)*;
singleContainerLabelsTable:
	OPENBR OPENBR 'svBag.container.labels' CLOSINGBR CLOSINGBR;
portMapping:
	portMappingTable NL containerPort NL hostPort NL protocol NL servicePort NL name;
portMappingTable:
	OPENBR OPENBR 'svBag.container.portMappings' CLOSINGBR CLOSINGBR;
servicePort: SERVICEPORT EQUAL DEC_INT;
image: IMAGE EQUAL BASIC_STRING;
network: NETWORK EQUAL BASIC_STRING;
parameters: parametersTable NL (keyValueStr NL)*;
parametersTable:
	OPENBR OPENBR 'svBag.container.parameters' CLOSINGBR CLOSINGBR;
privileged: PRIVILEGED EQUAL BOOLEAN;
credential: credentialTable NL principal NL credentialSecret;
credentialTable: OPENBR 'svBag.container.credential' CLOSINGBR;
principal: PRINCIPAL EQUAL BASIC_STRING;
credentialSecret: SECRET EQUAL BASIC_STRING;
volumes:
	volumesTable NL containerPath NL hostPath NL volumeMode;
volumesTable:
	OPENBR OPENBR 'svBag.container.volumes' CLOSINGBR CLOSINGBR;
hostPath: HOSTPATH EQUAL BASIC_STRING;
portDefinitions:
	portDefinitionsTable NL port NL protocol NL name NL portLabels;
portDefinitionsTable:
	OPENBR OPENBR 'svBag.portDefinitions' CLOSINGBR CLOSINGBR;
port: PORT EQUAL DEC_INT;
portLabels: portLabelsTable NL (keyValueStr NL)*;
portLabelsTable:
	OPENBR OPENBR 'svBag.portDefinitions.labels' CLOSINGBR CLOSINGBR;
mvBag:
	mvBagHeader NL mvBagID NL (instances NL)? (mvBagNetworks NL)? (
		mvBagNetwork NL
	)? (mvBagSecret NL)? (mvBagUser NL)? (mvBagVersion NL)? mvBagEnv? (
		mvBagExecutorResources NL
	)? mvBagLabels? (mvBagScaling NL)? (mvBagScheduling NL)? (
		mvBagContainers+ NL?
	)+ mvBagVolumes*;
mvBagHeader: OPENBR 'mvBag' CLOSINGBR;
mvBagID: applicationId;
restartPolicy: RESTART EQUAL RESTARTPOLICY;
mvBagNetworks: NETWORKS EQUAL str_array;
mvBagNetwork: mvBagNetworkTable NL keyValueStr;
mvBagNetworkTable: OPENBR 'mvBag.exposeOn' CLOSINGBR;
mvBagSecret: mvBagSecretsTable NL (mvBagSecretTable NL source)*;
mvBagSecretsTable:
	OPENBR OPENBR 'mvBag.secrets' CLOSINGBR CLOSINGBR;
mvBagSecretTable:
	OPENBR 'mvBag.secrets.' UNQUOTED_KEY CLOSINGBR;
mvBagUser: user;
mvBagVersion: version;
mvBagEnv: mvBagEnvTable NL (keyValueStr NL)*;
mvBagEnvTable:
	OPENBR OPENBR 'mvBag.environment' CLOSINGBR CLOSINGBR;
mvBagExecutorResources:
	mvBagExecutorResourcesTable NL cpu NL disk NL resourceMemory;
mvBagExecutorResourcesTable:
	OPENBR 'mvBag.executorResources' CLOSINGBR;
cpu: CPU EQUAL (FLOAT | DEC_INT);
resourceMemory: MEMORY EQUAL (FLOAT | DEC_INT);
disk: DISK EQUAL (FLOAT | DEC_INT);
mvBagLabels:
	mvBagLabelsTable NL (mvBagLabelApp NL)? (mvBagLabelTier NL)?;
mvBagLabelApp: APP EQUAL BASIC_STRING;
mvBagLabelTier: TIER EQUAL BASIC_STRING;
mvBagLabelsTable:
	OPENBR OPENBR 'mvBag.labels' CLOSINGBR CLOSINGBR;
mvBagScaling: mvBagScalingTable NL scalingType;
mvBagScalingTable: OPENBR 'mvBag.scaling' CLOSINGBR;
scalingType: KIND EQUAL BASIC_STRING;
mvBagScheduling:
	mvBagSchedulingTable NL killSelection NL placement NL unreachableStrategy NL upgrade NL
		schedulingBackoff;
mvBagSchedulingTable: OPENBR 'mvBag.scheduling' CLOSINGBR;
placement: PLACEMENT EQUAL BASIC_STRING;
unreachableStrategy: UNREACHABLESTRATEGY EQUAL BASIC_STRING;
upgrade: UPGRADE EQUAL BASIC_STRING;
schedulingBackoff:
	schedulingBackoffTable NL backoff NL backoffFactor NL maxLaunchDelay;
schedulingBackoffTable:
	OPENBR 'mvBag.scheduling.backoff' CLOSINGBR;
backoff: BACKOFF EQUAL (DEC_INT | FLOAT);
backoffFactor: BACKOFFFACTOR EQUAL (DEC_INT | FLOAT);
maxLaunchDelay: MAXLAUNCHDELAY EQUAL (DEC_INT | FLOAT);
mvBagContainers:
	containerTable NL (exec NL)? name NL (tty NL)? (
		restartPolicy NL
	)? (containerUser NL)? (check NL)? containerEnv? (
		containerHealthCheck NL
	)? containerImage containerLabels? (containerLifeCycle NL)? (
		containerResources NL
	)? (containerArtifacts NL)* containerNetworks* containerVolumes*;
containerTable:
	OPENBR OPENBR 'mvBag.containers' CLOSINGBR CLOSINGBR;
exec: EXEC EQUAL BASIC_STRING;
name: NAME EQUAL BASIC_STRING;
tty: TTY EQUAL BOOLEAN;
containerUser: mvBagUser;
containerEnv: containerEnvTable NL (keyValueStr NL)*;
containerEnvTable:
	OPENBR OPENBR 'mvBag.containers.environment' CLOSINGBR CLOSINGBR;
containerHealthCheck:
	containerHealthCheckTable NL (gracePeriodSeconds NL)? (
		ignoreHttp NL
	)? (intervalSeconds NL)? maxConsecutiveFailures NL (path NL)? (
		portIndex NL
	)? protocol NL timeoutSeconds;
containerHealthCheckTable:
	OPENBR 'mvBag.containers.healthcheck' CLOSINGBR;
gracePeriodSeconds: GRACEPER EQUAL (DEC_INT | FLOAT);
ignoreHttp: INGNOREHTTP EQUAL BOOLEAN;
maxConsecutiveFailures: MAXFAILURE EQUAL (DEC_INT | FLOAT);
protocol: PROTOCOL EQUAL BASIC_STRING;
containerImage:
	imageTable NL forcePull NL imageID NL imageKind NL (
		pullConfig NL
	)? imageLabels? imageCommands*;
imageTable: OPENBR 'mvBag.containers.image' CLOSINGBR;
forcePull: FORCEPULL EQUAL BOOLEAN;
imageID: applicationId;
imageKind: scalingType;
pullConfig: PULLCONFIG EQUAL BASIC_STRING;
imageLabels: imageLabelsTable NL (keyValueStr NL)*;
imageLabelsTable:
	OPENBR OPENBR 'mvBag.containers.image.labels' CLOSINGBR CLOSINGBR;
containerLabels: containerLabelsTable NL (keyValueStr NL)*;
containerLabelsTable:
	OPENBR OPENBR 'mvBag.containers.labels' CLOSINGBR CLOSINGBR;
containerLifeCycle: containerLifeCycleTable NL killGracePeriod;
containerLifeCycleTable:
	OPENBR 'mvBag.containers.lifecycle' CLOSINGBR;
killGracePeriod: KILLGRACEPERIODSECONDS EQUAL DEC_INT;
containerResources: containerResourcesTable NL cpus NL memory;
containerResourcesTable:
	OPENBR 'mvBag.containers.resources' CLOSINGBR;
cpus: CPUS EQUAL DEC_INT;
memory: MEM EQUAL DEC_INT;
containerArtifacts: containerArtifactsTable NL uri;
containerArtifactsTable:
	OPENBR OPENBR 'mvBag.containers.artifacts' CLOSINGBR CLOSINGBR;
uri: URI EQUAL BASIC_STRING;
containerNetworks:
	containerNetworkTable NL containerPort NL hostPort NL name NL (
		networkNames NL
	)? (protocol NL)? networkLabels?;
containerNetworkTable:
	OPENBR OPENBR 'mvBag.containers.networks' CLOSINGBR CLOSINGBR;
containerPort: CONTAINERPORT EQUAL DEC_INT;
hostPort: HOSTPORT EQUAL DEC_INT;
networkNames: NETWORKNAMES EQUAL str_array;
str_array: OPENBR str_array_values? comment_or_nl CLOSINGBR;
str_array_values: (
		comment_or_nl BASIC_STRING ',' str_array_values comment_or_nl
	)
	| comment_or_nl BASIC_STRING ','?;
int_array: '[' int_array_values? comment_or_nl ']';
int_array_values: (
		comment_or_nl DEC_INT ',' int_array_values comment_or_nl
	)
	| comment_or_nl DEC_INT ','?;
networkLabels: networkLabelsTable NL (keyValueStr NL)*;
networkLabelsTable:
	OPENBR OPENBR 'mvBag.containers.networks.labels' CLOSINGBR CLOSINGBR;
containerVolumes:
	containerVolumesTable NL mountPath NL name NL readOnly;
containerVolumesTable:
	OPENBR OPENBR 'mvBag.containers.volumeMounts' CLOSINGBR CLOSINGBR;
mountPath: MOUNTPATH EQUAL BASIC_STRING;
readOnly: READONLY EQUAL BOOLEAN;
mvBagVolumes:
	mvBagVolumesTable NL containerPath NL volumeMode NL volumePersistance;
mvBagVolumesTable:
	OPENBR OPENBR 'mvBag.volumes' CLOSINGBR CLOSINGBR;
containerPath: CONTAINERPATH EQUAL BASIC_STRING;
volumeMode: MODE EQUAL BASIC_STRING;
volumePersistance:
	volumePersistanceTable NL maxSize NL profileName NL size NL persistanceType NL constraint;
volumePersistanceTable:
	OPENBR 'mvBag.volumes.persistent' CLOSINGBR;
maxSize: MAXSIZE EQUAL DEC_INT;
profileName: PROFILENAME EQUAL BASIC_STRING;
size: SIZE EQUAL DEC_INT;
persistanceType: TYPE EQUAL BASIC_STRING;
constraint: constraintTable NL minItems NL maxItems;
constraintTable:
	OPENBR OPENBR 'mvBag.volumes.persistent.constraints' CLOSINGBR CLOSINGBR;
minItems: MINITEMS EQUAL DEC_INT;
maxItems: MAXITEMS EQUAL DEC_INT;
comment_or_nl: (COMMENT? NL)*;
keyValueStr: key '=' BASIC_STRING;
key: simpleKey | dottedKey;
simpleKey: UNQUOTED_KEY;
dottedKey: simpleKey ('.' simpleKey)+;
imageCommands:
	imageCommandsTable comment_or_nl (workDir comment_or_nl)? (
		runShell comment_or_nl
	)? (cmdShell comment_or_nl)? (runExec comment_or_nl)? (
		cmdExec comment_or_nl
	)? (copyCommand comment_or_nl)? (entrypoint comment_or_nl)? (
		addCommand comment_or_nl
	)?;
imageCommandsTable:
	OPENBR OPENBR 'mvBag.containers.image.commands' CLOSINGBR CLOSINGBR;
commands:
	commandsTable comment_or_nl (workDir comment_or_nl)? (
		runShell comment_or_nl
	)? (cmdShell comment_or_nl)? (runExec comment_or_nl)? (
		cmdExec comment_or_nl
	)? (copyCommand comment_or_nl)? (entrypoint comment_or_nl)? (
		addCommand comment_or_nl
	)?;

commandsTable:
	OPENBR OPENBR 'svBag.container.commands' CLOSINGBR CLOSINGBR;
runExec: RUN EQUAL BASIC_STRING;
runShell: RUNSHELL EQUAL str_array;
cmdExec: CMD EQUAL BASIC_STRING;
cmdShell: CMDSHELL EQUAL str_array;
addCommand:
	ADD EQUAL OPENBR NL? src ',' NL? BASIC_STRING NL? CLOSINGBR;
src: '.' | BASIC_STRING '.' BASIC_STRING | BASIC_STRING;
copyCommand:
	COPY EQUAL OPENBR NL? src ',' NL? BASIC_STRING NL? CLOSINGBR;
workDir: WORKDIR EQUAL src;
entrypoint:
	ENTRYPOINT EQUAL OPENBR NL? BASIC_STRING ',' NL? BASIC_STRING NL? CLOSINGBR;
/*
 * Lexer Rules
 */
ENTRYPOINT: 'entrypoint';
WORKDIR: 'workdir';
ADD: 'add';
COPY: 'copy';
RUN: 'run';
RUNSHELL: 'runShell';
ARGS: 'args';
MATCHEXPRESSIONS: 'matchExpressions';
DEPENDSON: 'dependsOn';
ACCEPTEDROLES: 'acceptedResourceRoles';
PORTS: 'ports';
INSTANCES: 'instances';
CMD: 'cmd';
CMDSHELL: 'cmdShell';
EXECUTOR: 'executor';
RESTARTPOLICY:
	'"' 'Always' '"'
	| '"' 'OnFailure' '"'
	| '"' 'Never' '"';
RESTART: 'restart';
EXPRESSIONOPERATOR:
	'"' 'UNIQUE' '"'
	| '"' 'CLUSTER' '"'
	| '"' 'GROUP_BY' '"'
	| '"' 'LIKE' '"'
	| '"' 'UNLIKE' '"'
	| '"' 'MAX_PER' '"'
	| '"' 'IS' '"'
	| '"' 'In' '"'
	| '"' 'NotIn' '"'
	| '"' 'Exists' '"'
	| '"' 'DoesNotExist' '"';
DEPENDENCIES: 'dependencies';
AUTHOR: 'author';
KILLSELECTION: 'killSelection';
PLACEMENT: 'placement';
UNREACHABLESTRATEGY: 'unreachableStrategy';
UPGRADE: 'upgrade';
EQUAL: '=';
KIND: 'kind';
ID: 'id';
IMAGE: 'image';
SECRETS: 'secrets';
SECRET: 'secret';
USER: 'user';
VERSION: 'version';
BACKOFF: 'backoff';
BACKOFFFACTOR: 'backoffFactor';
BACKOFFSECS: 'backoffSeconds';
MAXLAUNCHDELAY: 'maxLaunchDelaySeconds';
EXEC: 'exec';
NAME: 'name';
TTY: 'tty';
DELAYSEC: 'delaySeconds';
INTERVALSEC: 'intervalSeconds';
TIMEMOUTSEC: 'timeoutSeconds';
PATH: 'path';
PORTINDEX: 'portIndex';
SCHEME: 'scheme';
GRACEPER: 'gracePeriodSeconds';
INGNOREHTTP: 'ignoreHttp1xx';
MAXFAILURE: 'maxConsecutiveFailures';
PROTOCOL: 'protocol';
FORCEPULL: 'forcePull';
FORCEPULLIMAGE: 'forcePullImage';
PULLCONFIG: 'pullConfig';
KILLGRACEPERIODSECONDS: 'killGracePeriodSeconds';
TASKKILLGRACEPERIODSECONDS: 'taskKillGracePeriodSeconds';
KILLTYPE: '"' 'YOUNGEST_FIRST' '"' | '"' 'OLDEST_FIRST' '"';
CPUS: 'cpus';
MEM: 'mem';
CPU: 'cpu';
GPUS: 'gpus';
MEMORY: 'memory';
DISK: 'disk';
URI: 'uri';
APP: 'app';
TIER: 'tier';
CONTAINERPORT: 'containerPort';
HOSTPORT: 'hostPort';
HOSTPATH: 'hostPath';
NETWORKNAMES: 'networkNames';
NETWORKS: 'networks';
NETWORK: 'network';
MOUNTPATH: 'mountPath';
READONLY: 'readOnly';
CONTAINERPATH: 'containerPath';
MODE: 'mode';
MAXSIZE: 'maxSize';
PROFILENAME: 'profileName';
SIZE: 'size';
MINITEMS: 'minItems';
MAXITEMS: 'maxItems';
TYPE: 'type';
OPENBR: '[';
CLOSINGBR: ']';
PORT: 'port';
SERVICEPORT: 'servicePort';
PORTNAME: 'portName';
HTTPREADYSTATUSCODES: 'httpStatusCodesForReady';
PRESERVELASTRESPONSE: 'preserveLastResponse';
REQUIREPORTS: 'requirePorts';
MAXIMUMOVERCAPACITY: 'maximumOverCapacity';
MINIMUMHEALTHCAPACITY: 'minimumHealthCapacity';
SOURCE: 'source';
PRIVILEGED: 'privileged';
PRINCIPAL: 'principal';

WS: [ \t]+ -> skip;
NL: ('\r'? '\n')+;
COMMENT: '#' (~[\n])*;

fragment DIGIT: [0-9];
fragment ALPHA: [A-Za-z];

// booleans
BOOLEAN: 'true' | 'false';

// strings
fragment ESC: '\\' (["\\/bfnrt] | UNICODE | EX_UNICODE);
fragment ML_ESC: '\\' '\r'? '\n' | ESC;
fragment UNICODE: 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment EX_UNICODE:
	'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
BASIC_STRING: '"' (ESC | ~["\\\n])*? '"';
ML_BASIC_STRING: '"""' (ML_ESC | ~["\\])*? '"""';
LITERAL_STRING: '\'' (~['\n])*? '\'';
ML_LITERAL_STRING: '\'\'\'' (.)*? '\'\'\'';
// floating point numbers
fragment EXP: ('e' | 'E') DEC_INT;
fragment ZERO_PREFIXABLE_INT: DIGIT (DIGIT | '_' DIGIT)*;
fragment FRAC: '.' ZERO_PREFIXABLE_INT;
FLOAT: DEC_INT ( EXP | FRAC EXP?);
INF: [+-]? 'inf';
NAN: [+-]? 'nan';
// integers
fragment HEX_DIGIT: [A-F] | DIGIT;
fragment DIGIT_1_9: [1-9];
fragment DIGIT_0_7: [0-7];
fragment DIGIT_0_1: [0-1];
DEC_INT: [+-]? (DIGIT | (DIGIT_1_9 (DIGIT | '_' DIGIT)+));
HEX_INT: '0x' HEX_DIGIT (HEX_DIGIT | '_' HEX_DIGIT)*;
OCT_INT: '0o' DIGIT_0_7 (DIGIT_0_7 | '_' DIGIT_0_7);
BIN_INT: '0b' DIGIT_0_1 (DIGIT_0_1 | '_' DIGIT_0_1)*;
UNQUOTED_KEY: (ALPHA | DIGIT | '-' | '_')+;

