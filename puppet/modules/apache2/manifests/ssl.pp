# enable ssl
class apache2::ssl{
    apache2::load_module{ 'ssl': }
}
