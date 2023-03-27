import { Command } from 'commander';
import { promisify } from 'util';
import { exec } from 'child_process';
const execute = promisify(exec);
import figlet from 'figlet';
const { textSync } = figlet;
const program = new Command();
console.log(textSync("Dir Manager"));
program
    .version("1.0.0")
    .description("PSQL")
    .option("-l, --ls  [value]", "List directory contents")
    .option("-m, --mkdir <value>", "Create a directory")
    .option("-t, --touch <value>", "Create a file")
    .parse(process.argv);
const options = program.opts();
const psql = {
    name: 'sportevent-db',
    port: '5432',
    docker: {
        folder: 'psql'
    }
};
async function buildDockerImage(opts) {
    const { stdout, stderr } = await execute(`cd ${opts.docker.folder} && docker build -t ${opts.name} .`);
    console.log('stdout:', stdout);
    console.log('stderr:', stderr);
}
async function runDockerImage(opts) {
    const { stdout, stderr } = await execute(`docker run --name ${opts.name} -p ${opts.port}:${opts.port} -d ${opts.name}`);
    console.log('stdout:', stdout);
    console.log('stderr:', stderr);
}
buildDockerImage(psql).then(() => runDockerImage(psql));
//# sourceMappingURL=cli.js.map